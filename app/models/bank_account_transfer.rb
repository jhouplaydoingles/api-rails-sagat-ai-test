class BankAccountTransfer < ApplicationRecord
  def self.type_to_text
    {
      1 => 'PIX',
      2 => 'TED'
    }
  end
end
