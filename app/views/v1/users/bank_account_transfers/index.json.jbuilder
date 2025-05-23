json.bank_account_transfers @bank_account_transfers do |bank_account_transfer|
  json.id bank_account_transfer.id
  json.was_success bank_account_transfer.was_success
  json.transfer_type_text BankAccountTransfer.type_to_text[bank_account_transfer.transfer_type]
  json.amount_to_transfer bank_account_transfer.amount_to_transfer.to_f
  json.created_at bank_account_transfer.created_at
  
  user_bank_account = UserBankAccount.find_by(id: bank_account_transfer.to_user_bank_account_id)
  json.to_bank_account do 
    json.bank_name user_bank_account.bank_name
    json.bank_code  user_bank_account.bank_code
    json.agency_number  user_bank_account.agency_number
    json.agency_digit  user_bank_account.agency_digit
    json.account_number  user_bank_account.account_number
    json.account_digit  user_bank_account.account_digit
    json.account_type  user_bank_account.account_type
    json.document  user_bank_account.document
    json.holder_name  user_bank_account.holder_name
  end

  user_bank_account = UserBankAccount.find_by(id: bank_account_transfer.from_user_bank_account_id)
  json.from_user_bank_account do 
    json.bank_name user_bank_account.bank_name
    json.bank_code  user_bank_account.bank_code
    json.agency_number  user_bank_account.agency_number
    json.agency_digit  user_bank_account.agency_digit
    json.account_number  user_bank_account.account_number
    json.account_digit  user_bank_account.account_digit
    json.account_type  user_bank_account.account_type
    json.document  user_bank_account.document
    json.holder_name  user_bank_account.holder_name
  end
end

json.current_page @current_page
json.per_page @per_page
json.total_pages @total_pages
json.total_records  @total_records