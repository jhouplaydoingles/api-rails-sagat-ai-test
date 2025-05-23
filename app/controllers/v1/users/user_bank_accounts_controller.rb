module V1
  module Users
    class UserBankAccountsController < ApplicationController
      
      def index
        @user_bank_accounts = UserBankAccount.where.not(user_id: @user.id)
      end

      def my
        @user_bank_accounts = UserBankAccount.where(user_id: @user.id)
      end
    end
  end
end