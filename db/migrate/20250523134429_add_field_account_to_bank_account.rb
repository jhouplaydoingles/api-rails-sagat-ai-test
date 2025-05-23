class AddFieldAccountToBankAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :user_bank_accounts, :amount, :decimal
  end
end
