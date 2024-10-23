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

ActiveRecord::Schema[7.0].define(version: 2024_10_23_115648) do
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

end
