class CreateUserBankAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_bank_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :bank_name
      t.string :bank_code
      t.string :agency_number
      t.string :agency_digit
      t.string :account_number
      t.string :account_digit
      t.string :account_type
      t.string :document
      t.string :holder_name

      t.timestamps
    end
  end
end
