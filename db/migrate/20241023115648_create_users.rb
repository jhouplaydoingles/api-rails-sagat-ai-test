class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :position
      t.string :mobile_phone
      t.datetime :end_session
      t.boolean :is_deleted
      t.boolean :is_email_valid
      t.string :uid
      t.integer :otp_credential
      t.datetime :end_time_email
      t.integer :otp_recover_password
      t.datetime :end_time_recover_password
      t.string :current_user_ip

      t.timestamps
    end
  end
end
