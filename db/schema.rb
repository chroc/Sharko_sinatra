# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161221233604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boxes", force: :cascade do |t|
    t.string   "name"
    t.float    "balance"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "loans", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "box_id"
    t.float    "amount"
    t.integer  "term"
    t.float    "interest_fee"
    t.float    "balance"
    t.float    "amount_paid"
    t.float    "interest_paid"
    t.boolean  "approved"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.float    "interest"
    t.index ["box_id"], name: "index_loans_on_box_id", using: :btree
    t.index ["user_id"], name: "index_loans_on_user_id", using: :btree
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "loan_id"
    t.integer  "user_id"
    t.date     "transaction_date"
    t.string   "transaction_type"
    t.float    "amount"
    t.integer  "fee_number"
    t.float    "balance_amount"
    t.float    "interest_amount"
    t.float    "loan_balance"
    t.text     "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["loan_id"], name: "index_transactions_on_loan_id", using: :btree
    t.index ["user_id"], name: "index_transactions_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "address"
    t.string   "user_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "user_number"
    t.text     "password_digest"
  end

end
