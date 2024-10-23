if Rails.env.development?
  ActionMailer::Base.smtp_settings = {
    address: "mailhog",
    port: 1025
  }
  ActionMailer::Base.delivery_method = :smtp
end