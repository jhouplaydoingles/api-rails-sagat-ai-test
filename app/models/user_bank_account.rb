class UserBankAccount < ApplicationRecord
  belongs_to :user

  def self.create_fake_bank_account(user)
    UserBankAccount.create!(
      user: user,
      bank_name: "Banco Fictício #{rand(100..999)}",
      bank_code: rand(100..999).to_s,
      agency_number: rand(1000..9999).to_s,
      agency_digit: rand(0..9).to_s,
      account_number: rand(100000..999999).to_s,
      account_digit: rand(0..9).to_s,
      account_type: 'corrente',
      document: rand(100_000_000_00..999_999_999_99).to_s,
      holder_name: user.name,
      amount: rand(1000.9999)
    )

    UserBankAccount.create!(
      user: user,
      bank_name: "Banco Fictício #{rand(100..999)}",
      bank_code: rand(100..999).to_s,
      agency_number: rand(1000..9999).to_s,
      agency_digit: rand(0..9).to_s,
      account_number: rand(100000..999999).to_s,
      account_digit: rand(0..9).to_s,
      account_type: 'poupanca',
      document: rand(100_000_000_00..999_999_999_99).to_s,
      holder_name: user.name,
      amount: rand(1000.9999)
    )
  end
end
