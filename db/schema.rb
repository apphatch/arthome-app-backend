# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_21_093324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "checklists", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "shop_id"
    t.string "reference"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_checklists_on_shop_id"
    t.index ["user_id"], name: "index_checklists_on_user_id"
  end

  create_table "checklists_stocks", id: false, force: :cascade do |t|
    t.bigint "checklist_id"
    t.bigint "stock_id"
    t.index ["checklist_id"], name: "index_checklists_stocks_on_checklist_id"
    t.index ["stock_id"], name: "index_checklists_stocks_on_stock_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "importing_id"
    t.string "shop_type"
    t.string "full_address"
    t.string "city"
    t.string "district"
  end

  create_table "shops_stocks", id: false, force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "stock_id"
    t.index ["shop_id"], name: "index_shops_stocks_on_shop_id"
    t.index ["stock_id"], name: "index_shops_stocks_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "barcode"
    t.string "category"
    t.string "group"
    t.string "role"
    t.string "packaging"
    t.string "role_shop"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password_digest"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
