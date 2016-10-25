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

ActiveRecord::Schema.define(version: 20161025063112) do

  create_table "chapters", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "chapter_number", limit: 4
    t.integer  "subject_id",     limit: 4
    t.integer  "standard_id",    limit: 4
    t.integer  "class_id",       limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "code",           limit: 255
    t.integer  "stream_id",      limit: 4
  end

  add_index "chapters", ["code"], name: "index_chapters_on_code", unique: true, using: :btree
  add_index "chapters", ["stream_id"], name: "index_chapters_on_stream_id", using: :btree

  create_table "short_choice_answers", force: :cascade do |t|
    t.text     "answer_text",              limit: 65535
    t.boolean  "correct"
    t.integer  "short_choice_question_id", limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "label",                    limit: 255
    t.string   "image",                    limit: 255
  end

  add_index "short_choice_answers", ["short_choice_question_id"], name: "index_short_choice_answers_on_short_choice_question_id", using: :btree

  create_table "short_choice_questions", force: :cascade do |t|
    t.text     "question_text",              limit: 65535
    t.text     "hint_text",                  limit: 65535
    t.text     "answer_description",         limit: 65535
    t.integer  "sub_topic_id",               limit: 4
    t.integer  "topic_id",                   limit: 4
    t.integer  "chapter_id",                 limit: 4
    t.integer  "stream_id",                  limit: 4
    t.integer  "subject_id",                 limit: 4
    t.integer  "standard_id",                limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "passage_image",              limit: 255
    t.string   "question_image",             limit: 255
    t.boolean  "hint_available"
    t.text     "passage_footer",             limit: 65535
    t.integer  "linked_question_tid",        limit: 4
    t.integer  "sequence_no",                limit: 4
    t.string   "assertion",                  limit: 255
    t.text     "hint",                       limit: 65535
    t.text     "passage",                    limit: 65535
    t.integer  "solution_rating",            limit: 4
    t.integer  "correct_answer_id",          limit: 4
    t.string   "passage_header",             limit: 255
    t.string   "answer_image",               limit: 255
    t.text     "reason",                     limit: 65535
    t.string   "hint_image",                 limit: 255
    t.boolean  "multiple_correct"
    t.string   "question_style",             limit: 255
    t.integer  "level",                      limit: 4
    t.boolean  "answer_available"
    t.text     "answer",                     limit: 65535
    t.boolean  "question_linked"
    t.integer  "question_tid",               limit: 4
    t.string   "difficulty",                 limit: 255
    t.integer  "reference_solving_time",     limit: 4
    t.boolean  "include_in_diagnostic_test"
  end

  add_index "short_choice_questions", ["chapter_id"], name: "index_short_choice_questions_on_chapter_id", using: :btree
  add_index "short_choice_questions", ["difficulty"], name: "index_short_choice_questions_on_difficulty", using: :btree
  add_index "short_choice_questions", ["level"], name: "index_short_choice_questions_on_level", using: :btree
  add_index "short_choice_questions", ["standard_id"], name: "index_short_choice_questions_on_standard_id", using: :btree
  add_index "short_choice_questions", ["stream_id"], name: "index_short_choice_questions_on_stream_id", using: :btree
  add_index "short_choice_questions", ["sub_topic_id"], name: "index_short_choice_questions_on_sub_topic_id", using: :btree
  add_index "short_choice_questions", ["subject_id"], name: "index_short_choice_questions_on_subject_id", using: :btree
  add_index "short_choice_questions", ["topic_id"], name: "index_short_choice_questions_on_topic_id", using: :btree

  create_table "standards", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "standard_number", limit: 4
    t.string   "board",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "code",            limit: 255
  end

  add_index "standards", ["code"], name: "index_standards_on_code", unique: true, using: :btree

  create_table "streams", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "name",       limit: 255
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
    t.string   "code",            limit: 255
    t.integer  "stream_id",       limit: 4
  end

  add_index "sub_topics", ["code"], name: "index_sub_topics_on_code", unique: true, using: :btree
  add_index "sub_topics", ["stream_id"], name: "index_sub_topics_on_stream_id", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "full_name",   limit: 255
    t.integer  "standard_id", limit: 4
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "code",        limit: 255
  end

  add_index "subjects", ["code"], name: "index_subjects_on_code", unique: true, using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "topic_number", limit: 4
    t.integer  "subject_id",   limit: 4
    t.integer  "standard_id",  limit: 4
    t.integer  "class_id",     limit: 4
    t.integer  "chapter_id",   limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "code",         limit: 255
    t.integer  "stream_id",    limit: 4
    t.integer  "goal_tid",     limit: 4
    t.string   "description",  limit: 255
  end

  add_index "topics", ["code"], name: "index_topics_on_code", unique: true, using: :btree
  add_index "topics", ["stream_id"], name: "index_topics_on_stream_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "role",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
