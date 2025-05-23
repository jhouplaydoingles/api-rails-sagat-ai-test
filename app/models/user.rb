class User < ApplicationRecord
  has_secure_password

  before_create :make_uid

  validates :name, presence: true, on: :create
  validates :email, presence: true, on: :create
  validates :password, presence: true, on: :create

  has_many :user_bank_accounts
end
