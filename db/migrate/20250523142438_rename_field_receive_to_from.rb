class RenameFieldReceiveToFrom < ActiveRecord::Migration[7.0]
  def change
    rename_column :bank_account_transfers, :receive_user_bank_account_id, :from_user_bank_account_id
  end
end
