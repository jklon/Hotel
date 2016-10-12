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

ActiveRecord::Schema.define(version: 20161012214601) do

  create_table "chapters", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "chapter_number", limit: 4
    t.integer  "subject_id",     limit: 4
    t.integer  "standard_id",    limit: 4
    t.integer  "class_id",       limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "standards", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "number",     limit: 4
    t.string   "board",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sub_topics", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "subtopic_number", limit: 4
    t.integer  "subject_id",      limit: 4
    t.integer  "standard_id",     limit: 4
    t.integer  "class_id",        limit: 4
    t.integer  "chapter_id",      limit: 4
    t.integer  "topic_id",        limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "full_name",   limit: 255
    t.integer  "standard_id", limit: 4
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "topic_number", limit: 4
    t.integer  "subject_id",   limit: 4
    t.integer  "standard_id",  limit: 4
    t.integer  "class_id",     limit: 4
    t.integer  "chapter_id",   limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
