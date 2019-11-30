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

ActiveRecord::Schema.define(version: 2019_11_21_001917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "ticker"
    t.integer "shares"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deposits", force: :cascade do |t|
    t.integer "user_id"
    t.decimal "amount", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holdings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "company_id"
    t.integer "quantity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_holdings_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "price", precision: 12, scale: 2
    t.integer "company_id"
    t.integer "user_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_type"
    t.index ["company_id"], name: "index_orders_on_company_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "trades", force: :cascade do |t|
    t.integer "buy_order_id"
    t.integer "sell_order_id"
    t.integer "company_id"
    t.decimal "price", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_trades_on_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.decimal "balance", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
