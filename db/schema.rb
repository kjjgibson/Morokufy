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

ActiveRecord::Schema.define(version: 20161231084126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aliases", force: :cascade do |t|
    t.string   "alias_type"
    t.string   "alias_value"
    t.integer  "player_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "header_matches_predicates", force: :cascade do |t|
    t.string "header"
    t.string "expected_value"
  end

  create_table "key_present_predicates", force: :cascade do |t|
  end

  create_table "players", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "api_key"
    t.string   "shared_secret"
    t.string   "identifier"
  end

  create_table "rule_consequent_events", force: :cascade do |t|
    t.string   "consequent_type"
    t.integer  "achievement_id"
    t.string   "point_type"
    t.integer  "point_count"
    t.string   "event_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "value_matches_predicates", force: :cascade do |t|
    t.string "expected_value"
  end

  create_table "web_hook_alias_keys", force: :cascade do |t|
    t.integer  "web_hook_id"
    t.string   "alias_key"
    t.string   "alias_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["web_hook_id"], name: "index_web_hook_alias_keys_on_web_hook_id", using: :btree
  end

  create_table "web_hook_consequents", force: :cascade do |t|
    t.integer  "web_hook_rule_id"
    t.string   "event_name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["web_hook_rule_id"], name: "index_web_hook_consequents_on_web_hook_rule_id", using: :btree
  end

  create_table "web_hook_predicates", force: :cascade do |t|
    t.integer  "web_hook_rule_id"
    t.string   "key_path"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "actable_id"
    t.string   "actable_type"
    t.index ["web_hook_rule_id"], name: "index_web_hook_predicates_on_web_hook_rule_id", using: :btree
  end

  create_table "web_hook_rules", force: :cascade do |t|
    t.string   "name"
    t.integer  "web_hook_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["web_hook_id"], name: "index_web_hook_rules_on_web_hook_id", using: :btree
  end

  create_table "web_hooks", force: :cascade do |t|
    t.string   "name"
    t.string   "source_identifier"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_foreign_key "web_hook_alias_keys", "web_hooks"
  add_foreign_key "web_hook_consequents", "web_hook_rules"
  add_foreign_key "web_hook_predicates", "web_hook_rules"
  add_foreign_key "web_hook_rules", "web_hooks"
end
