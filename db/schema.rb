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

ActiveRecord::Schema.define(version: 2018_06_20_184527) do

  create_table "drums", force: :cascade do |t|
    t.integer "pedals"
    t.string "color"
    t.integer "cymbals"
    t.integer "toms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guitars", force: :cascade do |t|
    t.string "hand"
    t.string "color"
    t.string "material"
    t.integer "chords"
    t.boolean "digital"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "headphones", force: :cascade do |t|
    t.boolean "wireless"
    t.boolean "bluetooth"
    t.float "cable_length"
    t.integer "impedence"
    t.string "h_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "others", force: :cascade do |t|
    t.string "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pianos", force: :cascade do |t|
    t.string "tipo"
    t.string "color"
    t.string "material"
    t.integer "n_keys"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.string "brand"
    t.string "model"
    t.float "price"
    t.integer "quantity"
    t.float "weight"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "height"
    t.integer "length"
    t.integer "depth"
    t.string "image"
    t.integer "user_id"
    t.integer "type_id"
    t.string "type_name"
    t.string "instrum_type"
    t.integer "instrum_id"
    t.index ["instrum_type", "instrum_id"], name: "index_products_on_instrum_type_and_instrum_id"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "provider"
    t.string "uid"
    t.string "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
