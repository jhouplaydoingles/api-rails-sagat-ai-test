module V1
  module Users
    class BankAccountTransfersController < ApplicationController
      before_action :validations_before_transfer, only: [:create]

      def index
        @start_date = parse_date_param(:start_date) || 1.week.ago.beginning_of_day
        @end_date = parse_date_param(:end_date) || Time.current.end_of_day
        
        @min_value = parse_decimal_param(:min_value)
        @max_value = parse_decimal_param(:max_value)
        
        @transfer_type = params[:transfer_type]
        
        @per_page = parse_integer_param(:per_page) || 10
        @current_page = parse_integer_param(:page) || 1
        @current_page = 1 if @current_page < 1
        
        user_bank_account_ids = @user.user_bank_accounts.pluck(:id)
        
        base_query = BankAccountTransfer.where(created_at: @start_date..@end_date)
        
        case @transfer_type
        when 'sent'
          base_query = base_query.where(from_user_bank_account_id: user_bank_account_ids)
        when 'received'
          base_query = base_query.where(to_user_bank_account_id: user_bank_account_ids)
        else
          base_query = base_query.where(
            'to_user_bank_account_id IN (?) OR from_user_bank_account_id IN (?)',
            user_bank_account_ids,
            user_bank_account_ids
          )
        end
        
        base_query = base_query.where('amount_to_transfer >= ?', @min_value) if @min_value.present?
        base_query = base_query.where('amount_to_transfer <= ?', @max_value) if @max_value.present?
        
        @total_records = base_query.count
        @total_pages = (@total_records.to_f / @per_page).ceil
        @total_pages = 1 if @total_pages == 0
        
        @current_page = @total_pages if @current_page > @total_pages
        
        offset = (@current_page - 1) * @per_page
        
        @bank_account_transfers = base_query
          .order(created_at: :desc)
          .limit(@per_page)
          .offset(offset)
        
        @has_previous_page = @current_page > 1
        @has_next_page = @current_page < @total_pages
        @previous_page = @has_previous_page ? @current_page - 1 : nil
        @next_page = @has_next_page ? @current_page + 1 : nil
        
        @start_record = @total_records > 0 ? offset + 1 : 0
        @end_record = [@start_record + @per_page - 1, @total_records].min
      end

      def create
        success = [1, 2, 3, 4]
        error   = [6, 7]
        
        rand_number = rand(1..10)

        if error.include?(rand_number) && !bank_account_external_params[:make_success].present?
          create_bank_account_by_status(was_created: false)
          return render json: { message: 'Não foi possivel realizar a transferência' }, status: 422
        end

        if bank_account_external_params[:make_success] == false
          create_bank_account_by_status(was_created: false)
          return render json: { message: 'Não foi possivel realizar a transferência' }, status: 422
        end
        
        @from_user_bank_account.update(amount: @from_user_bank_account.amount.to_f - bank_account_transfer_params[:amount_to_transfer])
        @to_user_bank_account.update(amount: @to_user_bank_account.amount.to_f + bank_account_transfer_params[:amount_to_transfer])
        create_bank_account_by_status(was_created: true)

        return render json: { message: 'Transferencia realizada com sucesso!' }
      end
      
      private

      def validations_before_transfer
        @to_user_bank_account   = UserBankAccount.find_by(id: bank_account_transfer_params[:to_user_bank_account_id])
        @from_user_bank_account = UserBankAccount.find_by(id: bank_account_transfer_params[:from_user_bank_account_id], user_id: @user.id)

        return render json: { message: "Conta de destino não existe." }, status: 404 if @to_user_bank_account.nil?
        return render json: { message: "Conta de origem não existe." }, status: 404 if @from_user_bank_account.nil?

        has_enough_amount = @from_user_bank_account.amount.to_f > bank_account_transfer_params[:amount_to_transfer]

        return render json: { message: "Valor insuficiente para suprir transferência." }, status: 403 unless has_enough_amount

        unless [1, 2].include?(bank_account_transfer_params[:transfer_type])
          return render json: { message: "Tipo de transferência #{bank_account_transfer_params[:transfer_type]} não existe."}, status: 404
        end
      end

      def create_bank_account_by_status(was_created: )
        bank_account_created = BankAccountTransfer.create(bank_account_transfer_params.merge({was_success: was_created}))

        return render json: { message: bank_account_created.errors.join(' AND ') }, status: 422 unless bank_account_created.valid?
      end

      def parse_date_param(param_key)
        return nil unless params[param_key].present?
        
        begin
          Date.parse(params[param_key])
        rescue ArgumentError
          nil
        end
      end

      def parse_decimal_param(param_key)
        return nil unless params[param_key].present?
        
        begin
          BigDecimal(params[param_key].to_s)
        rescue ArgumentError, TypeError
          nil
        end
      end

      def parse_integer_param(param_key)
        return nil unless params[param_key].present?
        
        begin
          params[param_key].to_i
        rescue ArgumentError, TypeError
          nil
        end
      end

      def bank_account_transfer_params
        params.require(:bank_account_transfer).permit(
          :to_user_bank_account_id, 
          :from_user_bank_account_id, 
          :transfer_type,
          :amount_to_transfer
        )
      end

      def bank_account_external_params
        params.permit(:make_success)
      end
    end
  end
end