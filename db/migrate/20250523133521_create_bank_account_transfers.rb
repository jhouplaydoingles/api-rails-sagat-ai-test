class CreateBankAccountTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_account_transfers do |t|
      t.boolean :was_success
      t.integer :to_user_bank_account_id
      t.integer :transfer_type
      t.integer :receive_user_bank_account_id
      t.decimal :amount_to_transfer

      t.timestamps
    end

    add_index :bank_account_transfers, :to_user_bank_account_id
    add_index :bank_account_transfers, :receive_user_bank_account_id
  end
end
