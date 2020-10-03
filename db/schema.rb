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

ActiveRecord::Schema.define(version: 2020_10_03_023307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "checkin_checkouts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "shop_id"
    t.datetime "time"
    t.text "note"
    t.boolean "is_checkin", default: false
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "checkin_id"
    t.index ["shop_id"], name: "index_checkin_checkouts_on_shop_id"
    t.index ["user_id"], name: "index_checkin_checkouts_on_user_id"
  end

  create_table "checklist_items", force: :cascade do |t|
    t.bigint "checklist_id"
    t.bigint "stock_id"
    t.string "importing_id"
    t.json "data"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "quantity"
    t.string "mechanic"
    t.string "photo_ref"
    t.index ["checklist_id"], name: "index_checklist_items_on_checklist_id"
    t.index ["stock_id"], name: "index_checklist_items_on_stock_id"
  end

  create_table "checklists", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "shop_id"
    t.string "reference"
    t.string "checklist_type"
    t.boolean "deleted", default: false
    t.boolean "completed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "yearweek"
    t.datetime "date"
    t.index ["shop_id"], name: "index_checklists_on_shop_id"
    t.index ["user_id"], name: "index_checklists_on_user_id"
  end

  create_table "checklists_stocks", id: false, force: :cascade do |t|
    t.bigint "checklist_id"
    t.bigint "stock_id"
    t.index ["checklist_id"], name: "index_checklists_stocks_on_checklist_id"
    t.index ["stock_id"], name: "index_checklists_stocks_on_stock_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "name"
    t.string "path"
    t.datetime "time"
    t.string "dbfile_type"
    t.bigint "dbfile_id"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dbfile_type", "dbfile_id"], name: "index_photos_on_dbfile_type_and_dbfile_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.string "importing_id"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "shop_type"
    t.string "full_address"
    t.string "city"
    t.string "district"
    t.json "custom_attributes"
  end

  create_table "shops_stocks", id: false, force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "stock_id"
    t.index ["shop_id"], name: "index_shops_stocks_on_shop_id"
    t.index ["stock_id"], name: "index_shops_stocks_on_stock_id"
  end

  create_table "shops_users", id: false, force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "user_id"
    t.index ["shop_id"], name: "index_shops_users_on_shop_id"
    t.index ["user_id"], name: "index_shops_users_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.string "importing_id"
    t.string "sku"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "barcode"
    t.json "custom_attributes"
    t.string "role", default: "stock"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "importing_id"
    t.string "username"
    t.string "password_digest"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role"
    t.boolean "locked", default: false
    t.string "jwt"
    t.integer "failed_login_attempts", default: 0
  end

  create_table "worker_requests", force: :cascade do |t|
    t.string "worker_class"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "checkin_checkouts", "shops"
  add_foreign_key "checkin_checkouts", "users"
end
