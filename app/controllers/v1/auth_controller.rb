module V1
  class AuthController < ApplicationController
    before_action :validate_existing_user, only: [:sign_up]

    def sign_in
      end_session = Time.now + 50.minutes
      @user = User.find_by(email: user_params[:email])

      if @user && @user.authenticate(user_params[:password])
        return render json: {success: false,  message: 'Acesso negado' }, status: :unauthorized if @user.is_deleted == true
        @user.update(end_session: end_session , current_user_ip: request.remote_ip )
        token = encode_token({ user_id: @user.id, end_session: end_session.iso8601 })
        render json: { success: true, token: token, exp: end_session.to_i }
      else
        render json: { success: false,  message: 'Usuário ou Senha incorretos' }, status: :unauthorized
      end
    end

    def sign_up
      end_session = Time.now + 50.minutes

      @user = User.create(user_params)

      return render json: { success: false, message: @user.errors.full_messages.join(", ") }, status: 422 unless @user.valid?7
      
      create_fake_bank_account

      @user.update(end_session: end_session , current_user_ip: request.remote_ip )
      
      token = encode_token({ user_id: @user.id, end_session: end_session.iso8601 })

      render json: { success: true, token: token, exp: end_session.to_i }
    end

    private

    def create_fake_bank_account
      UserBankAccount.create_fake_bank_account(@user)
    end
    
    def validate_existing_user
      existing_user = User.find_by(email: user_params[:email])

      return render json: {success: false, message: "Ja existe um Usuario com esse E-mail"}, status: 401 if existing_user
    end

    def user_params
      params.require(:user).permit(:name, :password, :credential, :email).tap do |user_params|
        user_params[:email] = user_params[:email].strip
      end
    end
  end
end