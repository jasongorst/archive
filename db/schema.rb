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

ActiveRecord::Schema[7.2].define(version: 2024_10_17_023619) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.boolean "admin", default: false, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bot_user_id"
    t.index ["bot_user_id"], name: "index_accounts_on_bot_user_id"
    t.index ["confirmation_token"], name: "index_accounts_on_confirmation_token", unique: true
    t.index ["email"], name: "index_accounts_on_email"
    t.index ["remember_token"], name: "index_accounts_on_remember_token", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachable_type", null: false
    t.bigint "attachable_id", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable"
  end

  create_table "bot_users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "slack_user"
    t.string "display_name"
    t.string "user_access_token"
    t.string "user_oauth_scope"
    t.boolean "active", default: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_user"], name: "index_bot_users_on_slack_user", unique: true
    t.index ["team_id"], name: "index_bot_users_on_team_id"
  end

  create_table "channels", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "slack_channel"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "archived", default: false, null: false
    t.index ["name"], name: "index_channels_on_name"
    t.index ["slack_channel"], name: "index_channels_on_slack_channel"
  end

  create_table "custom_emojis", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["name"], name: "index_custom_emojis_on_name"
  end

  create_table "emoji_aliases", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.string "alias_for"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_emoji_aliases_on_name"
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "text"
    t.decimal "ts", precision: 20, scale: 6
    t.bigint "user_id", null: false
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "posted_on", null: false
    t.datetime "posted_at", null: false
    t.text "verbatim"
    t.index ["channel_id"], name: "index_messages_on_channel_id"
    t.index ["posted_at"], name: "index_messages_on_posted_at"
    t.index ["posted_on"], name: "index_messages_on_posted_on"
    t.index ["ts"], name: "index_messages_on_ts"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "private_channels", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "slack_channel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "channel_created_at"
    t.string "name"
    t.boolean "archived", default: false, null: false
    t.index ["slack_channel"], name: "index_private_channels_on_slack_channel"
  end

  create_table "private_channels_users", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "private_channel_id", null: false
    t.bigint "user_id", null: false
    t.index ["private_channel_id", "user_id"], name: "index_private_channels_users_on_private_channel_id_and_user_id"
    t.index ["user_id", "private_channel_id"], name: "index_private_channels_users_on_user_id_and_private_channel_id"
  end

  create_table "private_messages", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "text"
    t.text "verbatim"
    t.decimal "ts", precision: 20, scale: 6
    t.bigint "private_channel_id", null: false
    t.bigint "user_id", null: false
    t.date "posted_on"
    t.datetime "posted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["posted_at"], name: "index_private_messages_on_posted_at"
    t.index ["posted_on"], name: "index_private_messages_on_posted_on"
    t.index ["private_channel_id"], name: "index_private_messages_on_private_channel_id"
    t.index ["ts"], name: "index_private_messages_on_ts"
    t.index ["user_id"], name: "index_private_messages_on_user_id"
  end

  create_table "teams", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "team_id"
    t.string "name"
    t.string "domain"
    t.string "token"
    t.string "oauth_scope"
    t.string "oauth_version", default: "v2", null: false
    t.string "bot_user_id"
    t.string "activated_user_id"
    t.string "activated_user_access_token"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "slack_user"
    t.string "display_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.boolean "is_bot", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.index ["slack_user"], name: "index_users_on_slack_user"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bot_users", "teams"
  add_foreign_key "messages", "channels"
  add_foreign_key "messages", "users"
  add_foreign_key "private_messages", "private_channels"
  add_foreign_key "private_messages", "users"
end
