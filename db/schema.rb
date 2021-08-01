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

ActiveRecord::Schema.define(version: 2021_07_31_235239) do

  create_table "attachments", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.bigint "message_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id"], name: "index_attachments_on_message_id"
  end

  create_table "channels", charset: "utf8mb4", force: :cascade do |t|
    t.string "slack_channel"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_channels_on_name"
    t.index ["slack_channel"], name: "index_channels_on_slack_channel"
  end

  create_table "messages", charset: "utf8mb4", force: :cascade do |t|
    t.text "text"
    t.decimal "ts", precision: 20, scale: 6
    t.bigint "user_id", null: false
    t.bigint "channel_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "posted_on", null: false
    t.datetime "posted_at", precision: 6, null: false
    t.index ["channel_id"], name: "index_messages_on_channel_id"
    t.index ["posted_at"], name: "index_messages_on_posted_at"
    t.index ["posted_on"], name: "index_messages_on_posted_on"
    t.index ["ts"], name: "index_messages_on_ts"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "slack_user"
    t.string "display_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "color", default: "inherit"
    t.index ["slack_user"], name: "index_users_on_slack_user"
  end

  add_foreign_key "attachments", "messages"
  add_foreign_key "messages", "channels"
  add_foreign_key "messages", "users"
end
