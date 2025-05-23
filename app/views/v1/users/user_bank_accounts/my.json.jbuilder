json.user_bank_accounts @user.user_bank_accounts do |user_bank_account|
  json.id user_bank_account.id
  json.bank_name user_bank_account.bank_name
  json.bank_code user_bank_account.bank_code
  json.agency_number user_bank_account.agency_number
  json.agency_digit user_bank_account.agency_digit
  json.account_number user_bank_account.account_number
  json.account_digit user_bank_account.account_digit
  json.account_type user_bank_account.account_type
  json.document user_bank_account.document
  json.holder_name user_bank_account.holder_name
  json.created_at user_bank_account.created_at 
  json.updated_at user_bank_account.updated_at
  json.amount user_bank_account.amount.to_f
end