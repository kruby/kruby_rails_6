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

ActiveRecord::Schema.define(version: 2021_10_21_134015) do

  create_table "assets", charset: "utf8mb3", force: :cascade do |t|
    t.string "description"
    t.string "caption"
    t.integer "user_id"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "attachable_type"
    t.integer "attachable_id"
    t.string "description"
    t.string "image_size"
    t.integer "position"
    t.integer "asset_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contents", charset: "utf8mb3", force: :cascade do |t|
    t.integer "resource_id"
    t.string "resource_type"
    t.integer "parent_id"
    t.string "navlabel"
    t.boolean "active"
    t.boolean "redirect"
    t.string "controller_redirect"
    t.string "action_redirect"
    t.integer "position"
    t.string "controller_name"
    t.string "category", default: "Admin"
    t.string "string", default: "Admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hours", charset: "utf8mb3", force: :cascade do |t|
    t.string "description"
    t.decimal "number", precision: 10, scale: 2
    t.decimal "decimal", precision: 10, scale: 2
    t.date "date"
    t.integer "user_id"
    t.integer "partner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "menus", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.text "body"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pages", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "headline"
    t.text "body"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "partners", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "postno"
    t.string "city"
    t.text "log"
    t.string "category"
    t.string "responsible"
    t.text "info"
    t.datetime "next_action"
    t.integer "lock_version"
    t.integer "user_id"
    t.integer "search_lock"
    t.string "phone"
    t.string "email"
    t.string "homepage"
    t.string "status"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "posts", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "position"
    t.integer "parent_id", default: 0
    t.integer "user_id"
    t.boolean "active", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "preferences", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean "active"
    t.string "category"
    t.string "blogname"
    t.string "password_hash"
    t.string "password_salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vouchers", charset: "utf8mb3", force: :cascade do |t|
    t.string "description"
    t.decimal "number", precision: 10, scale: 2
    t.decimal "decimal", precision: 10, scale: 2
    t.integer "partner_id"
    t.date "date"
    t.integer "user_id"
    t.integer "hourly_rate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
