class User < ApplicationRecord
  has_secure_password

  before_create :make_uid
end
