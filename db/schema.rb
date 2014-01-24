# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140122150229) do

  create_table "airtime_vouchers", force: true do |t|
    t.integer  "redeem_winning_id"
    t.integer  "user_account_id"
    t.string   "freepaid_refno"
    t.string   "network"
    t.string   "pin"
    t.float    "sellvalue"
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "airtime_vouchers", ["created_at"], name: "index_airtime_vouchers_on_created_at", using: :btree
  add_index "airtime_vouchers", ["redeem_winning_id"], name: "index_airtime_vouchers_on_redeem_winning_id", using: :btree
  add_index "airtime_vouchers", ["updated_at"], name: "index_airtime_vouchers_on_updated_at", using: :btree
  add_index "airtime_vouchers", ["user_account_id"], name: "index_airtime_vouchers_on_user_account_id", using: :btree

  create_table "feedback", force: true do |t|
    t.integer  "user_account_id"
    t.string   "subject"
    t.text     "message"
    t.string   "support_type",    default: "suggestion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedback", ["user_account_id"], name: "index_feedback_on_user_account_id", using: :btree

  create_table "purchase_transactions", force: true do |t|
    t.integer  "user_account_id"
    t.string   "product_id",          null: false
    t.string   "product_name",        null: false
    t.text     "product_description"
    t.integer  "moola_amount",        null: false
    t.string   "currency_amount",     null: false
    t.string   "ref"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "purchase_transactions", ["user_account_id"], name: "index_purchase_transactions_on_user_account_id", using: :btree

  create_table "redeem_winnings", force: true do |t|
    t.integer  "user_account_id"
    t.integer  "prize_amount"
    t.string   "prize_type"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "mxit_money_reference"
  end

  add_index "redeem_winnings", ["user_account_id"], name: "index_redeem_winnings_on_user_account_id", using: :btree

  create_table "user_accounts", force: true do |t|
    t.string   "uid",                        null: false
    t.string   "provider",                   null: false
    t.string   "mxit_login"
    t.string   "name"
    t.string   "real_name"
    t.string   "mobile_number"
    t.string   "email"
    t.integer  "credits",       default: 24
    t.integer  "prize_points",  default: 0
    t.integer  "lock_version",  default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
