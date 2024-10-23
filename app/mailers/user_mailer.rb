class UserMailer < ApplicationMailer
  def send_credential_email
    @user = params[:user]

    generate_token = "#{@user.uid}#{@user.otp_credential}"
    @confirmation_url = "#{(ENV['BASE_URL'] || 'http://localhost:3000')}/v1/auth/confirm_email?token=#{generate_token}"
    mail(to: @user.email, from: 'sagat.support@outlook.com', subject: "CONFIRMAÇÃO DE EMAIL")
  end

  def send_recover_password_email
    @user = params[:user]

    generate_token = "#{@user.uid}#{@user.otp_recover_password}"
    @confirmation_url = "#{(ENV['BASE_URL'] || 'http://localhost:3000')}/v1/auth/confirm_recover_password?token=#{generate_token}"
    mail(to: @user.email, from: 'sagat.support@outlook.com', subject: "RECUPERAÇÃO DE SENHA")
  end
end
