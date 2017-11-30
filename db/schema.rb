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

ActiveRecord::Schema.define(version: 20170809191740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaigns", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.string "short_description"
    t.string "description", null: false
    t.boolean "is_public", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "campaigns_users", id: :serial, force: :cascade do |t|
    t.integer "campaign_id", null: false
    t.integer "user_id", null: false
    t.index ["campaign_id", "user_id"], name: "index_campaigns_users_on_campaign_id_and_user_id", unique: true
  end

  create_table "content_texts", id: :serial, force: :cascade do |t|
    t.text "content", null: false
    t.integer "order"
    t.integer "visibility", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "hierarchy_element_id"
    t.index ["hierarchy_element_id"], name: "index_content_texts_on_hierarchy_element_id"
    t.index ["visibility"], name: "index_content_texts_on_visibility"
  end

  create_table "content_texts_users", id: false, force: :cascade do |t|
    t.integer "content_text_id", null: false
    t.integer "user_id", null: false
    t.index ["content_text_id", "user_id"], name: "content_texts_users_uniqueness", unique: true
    t.index ["content_text_id"], name: "index_content_texts_users_on_content_text_id"
    t.index ["user_id"], name: "index_content_texts_users_on_user_id"
  end

  create_table "hierarchy_elements", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "visibility", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "hierarchable_id"
    t.string "hierarchable_type"
    t.string "description"
    t.index ["hierarchable_type", "hierarchable_id"], name: "index_hierachy_elements_on_hierarchable"
    t.index ["visibility"], name: "index_hierarchy_elements_on_visibility"
  end

  create_table "hierarchy_elements_users", id: false, force: :cascade do |t|
    t.integer "hierarchy_element_id", null: false
    t.integer "user_id", null: false
    t.index ["hierarchy_element_id", "user_id"], name: "hierarchy_elements_users_uniqueness", unique: true
    t.index ["hierarchy_element_id"], name: "index_hierarchy_elements_users_on_hierarchy_element_id"
    t.index ["user_id"], name: "index_hierarchy_elements_users_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "remember_token"
    t.string "locale", default: "de", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
  end

end
