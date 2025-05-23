# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_05_23_142438) do
  create_table "bank_account_transfers", force: :cascade do |t|
    t.boolean "was_success"
    t.integer "to_user_bank_account_id"
    t.integer "transfer_type"
    t.integer "from_user_bank_account_id"
    t.decimal "amount_to_transfer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_bank_account_id"], name: "index_bank_account_transfers_on_from_user_bank_account_id"
    t.index ["to_user_bank_account_id"], name: "index_bank_account_transfers_on_to_user_bank_account_id"
  end

  create_table "user_bank_accounts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "bank_name"
    t.string "bank_code"
    t.string "agency_number"
    t.string "agency_digit"
    t.string "account_number"
    t.string "account_digit"
    t.string "account_type"
    t.string "document"
    t.string "holder_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount"
    t.index ["user_id"], name: "index_user_bank_accounts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "position"
    t.string "mobile_phone"
    t.datetime "end_session"
    t.boolean "is_deleted"
    t.boolean "is_email_valid"
    t.string "uid"
    t.integer "otp_credential"
    t.datetime "end_time_email"
    t.integer "otp_recover_password"
    t.datetime "end_time_recover_password"
    t.string "current_user_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "user_bank_accounts", "users"
end
