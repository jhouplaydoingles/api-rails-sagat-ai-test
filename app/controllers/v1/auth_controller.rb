module V1
  class AuthController < ApplicationController
    before_action :validate_existing_user, only: [:sign_up]

    def sign_in
      end_session = Time.now + 5.minutes
      @user = User.find_by(email: user_params[:email])

      if @user && @user.authenticate(user_params[:password])
        return render json: {success: false,  message: 'Verifique seu Email antes de continuar'}, status: :unauthorized if @user.is_email_valid == false
        return render json: {success: false,  message: 'Acesso negado' }, status: :unauthorized if @user.is_deleted == true
        @user.update(end_session: end_session , current_user_ip: request.remote_ip )
        token = encode_token({ user_id: @user.id, end_session: end_session.iso8601 })
        render json: {success: true,  user: @user.uid, token: token }
      else
        render json: {success: false,  message: 'Usuário ou Senha incorretos' }, status: :unauthorized
      end
    end

    def sign_up
      @user = User.create(user_params)

      return render json: { success: false, message: @user.errors.full_messages.join(", ") }, status: 422 unless @user.valid?

      @user.update(otp_credential: rand(1000..9999), end_time_email: Time.now + 1.minutes)

      UserMailer.with(
        user: @user
      ).send_credential_email.deliver_now

      render json: { success: true, message: "Um E-mail de confirmação foi enviado para o usuario" }
    end

    def resend_credential_email
      @user = User.find_by(email: user_params[:email], is_email_valid: [nil, false])

      return render json: { success: false, message: "Usuario não encontrado ou ja verificado" }, status: 404 if @user.nil?

      return render json: { success: false, message: "Aguarde até fazer outra solicitação" }, status: 404 if @user.end_time_email > Time.now

      @user.update(otp_credential: rand(1000..9999), end_time_email: Time.now + 1.minutes)

      UserMailer.with(
        user: @user
      ).send_credential_email.deliver_now
    end

    def recover_password
      @user = User.find_by(email: user_params[:email], is_email_valid: true)

      return render json: {success: false, message: "Usuario nao encontrado" }, status: 404 if @user.nil?

      return render json: {success: false, message: "Aguarde até fazer outra solicitação" }, status: 404 if @user.end_time_recover_password && @user.end_time_recover_password > Time.now

      @user.update(otp_recover_password: rand(1000..9999), end_time_recover_password: Time.now + 1.minutes)

      UserMailer.with(
        user: @user
      ).send_recover_password_email.deliver_now
    end

    def confirm_email
      error_file = "#{Rails.root}/public/422.html"
      token_generated = params[:token]

      return render file: error_file unless params[:token].present?

      user = User.find_by(uid: token_generated[0..-5])

      return render file: error_file if user.nil?

      return render file: error_file if user.end_time_email < Time.now

      credential = token_generated.slice(-4, 4)

      return render file: error_file unless credential.to_i == user.otp_credential

      user.update(is_email_valid: true)
      
      return render file: "#{Rails.root}/public/success_email_validation.html"
    end

    def validate_existing_user
      existing_user = User.find_by(email: user_params[:email])

      return render json: {success: false, message: "Ja existe um Usuario com esse E-mail"}, status: 401 if existing_user
    end

    def confirm_recover_password      
      error_file = "#{Rails.root}/public/422.html"
      token_generated = params[:token]

      return render file: error_file unless params[:token].present?

      user = User.find_by(uid: token_generated[0..-5])

      return render file: error_file if user.nil?

      return render file: error_file if user.end_time_recover_password < Time.now

      credential = token_generated.slice(-4, 4)

      return render file: error_file unless credential.to_i == user.otp_recover_password

      if params[:new_password]
        user.update(password: params[:new_password], end_time_recover_password: Time.now)
        return render file: "#{Rails.root}/public/success_recover_validation.html"
      end
      generate_token = "#{user.uid}#{user.otp_recover_password}"
      @confirmation_url = "#{(ENV['BASE_URL'] || 'http://localhost:3000')}/v1/auth/confirm_recover_password?token=#{generate_token}"
    end

    private

    def user_params
      params.require(:user).permit(:username, :password, :credential, :email).tap do |user_params|
        user_params[:email] = user_params[:email].strip
      end
    end
  end
end