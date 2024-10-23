module V1
  module Users
    class ApplicationController < ActionController::API
      before_action :authorize
      # before_action :set_current_user

      def decode_token
        auth_header = request.headers['Authorization']

        return unless auth_header

        token = auth_header.split(' ')[1]
        begin
          JWT.decode(token, 'secret', true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end

      def authorized_user
        decoded_token = decode_token
        
        return render json: { error: 'Token não esta no formato correto' }, status: :unauthorized unless decode_token

        user_id = decode_token[0]['user_id']
        input_time_str = decode_token[0]['end_session']
        input_time = Time.parse(input_time_str)
        local_time = input_time.in_time_zone

        @user = User.find_by(id: user_id)

        return false if @user.nil?
        return render json: { error: 'Acesso negado' }, status: :unauthorized if @user.is_deleted == true
        return render json: { error: 'Sua conta foi logada em outro local ou Token expirou'}, status: :unauthorized unless @user.end_session.to_i == local_time.to_i
        return render json: { error: 'Verifique seu Email antes de continuar'}, status: :unauthorized if @user.is_email_valid == false

        return false if @user.end_session < Time.now
        @user
      end

      def authorize
        unless authorized_user
          render json: { message: 'Talvez você não possua o token ou expirou' }, status: :unauthorized
        end
      end
    end
  end
end