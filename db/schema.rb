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

ActiveRecord::Schema.define(version: 20161117115802) do

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

  create_table "diagnostic_test_questions", force: :cascade do |t|
    t.string   "question_type",      limit: 255
    t.integer  "question_id",        limit: 4
    t.integer  "diagnostic_test_id", limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "diagnostic_tests", force: :cascade do |t|
    t.integer  "standard_id", limit: 4
    t.integer  "subject_id",  limit: 4
    t.string   "name",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "difficulty_levels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "value",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "extra_marks_answers", force: :cascade do |t|
    t.integer  "extra_marks_question_id", limit: 4
    t.boolean  "correct"
    t.text     "answer_text",             limit: 65535
    t.string   "label",                   limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "em_answer_id",            limit: 4
  end

  add_index "extra_marks_answers", ["extra_marks_question_id"], name: "index_extra_marks_answers_on_extra_marks_question_id", using: :btree

  create_table "extra_marks_questions", force: :cascade do |t|
    t.integer  "em_question_id",     limit: 4
    t.text     "question_text",      limit: 65535
    t.string   "question_type",      limit: 255
    t.text     "answer_description", limit: 65535
    t.string   "difficulty",         limit: 255
    t.integer  "level",              limit: 4
    t.string   "answer_type",        limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "standard_id",        limit: 4
    t.integer  "chapter_id",         limit: 4
    t.integer  "subject_id",         limit: 4
    t.integer  "topic_id",           limit: 4
  end

  add_index "extra_marks_questions", ["chapter_id"], name: "index_extra_marks_questions_on_chapter_id", using: :btree
  add_index "extra_marks_questions", ["em_question_id"], name: "index_extra_marks_questions_on_em_question_id", using: :btree
  add_index "extra_marks_questions", ["level"], name: "index_extra_marks_questions_on_level", using: :btree
  add_index "extra_marks_questions", ["standard_id"], name: "index_extra_marks_questions_on_standard_id", using: :btree
  add_index "extra_marks_questions", ["subject_id"], name: "index_extra_marks_questions_on_subject_id", using: :btree

  create_table "proficiency_levels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "value",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "second_topics", force: :cascade do |t|
    t.integer  "chapter_id",  limit: 4
    t.integer  "subject_id",  limit: 4
    t.integer  "standard_id", limit: 4
    t.string   "name",        limit: 255
    t.integer  "stream_id",   limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "second_topics", ["chapter_id"], name: "index_second_topics_on_chapter_id", using: :btree
  add_index "second_topics", ["standard_id"], name: "index_second_topics_on_standard_id", using: :btree
  add_index "second_topics", ["stream_id"], name: "index_second_topics_on_stream_id", using: :btree
  add_index "second_topics", ["subject_id"], name: "index_second_topics_on_subject_id", using: :btree

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
    t.integer  "second_topic_id",            limit: 4
  end

  add_index "short_choice_questions", ["chapter_id"], name: "index_short_choice_questions_on_chapter_id", using: :btree
  add_index "short_choice_questions", ["difficulty"], name: "index_short_choice_questions_on_difficulty", using: :btree
  add_index "short_choice_questions", ["level"], name: "index_short_choice_questions_on_level", using: :btree
  add_index "short_choice_questions", ["second_topic_id"], name: "index_short_choice_questions_on_second_topic_id", using: :btree
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

  create_table "user_entity_scores", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "entity_name", limit: 255
    t.integer  "entity_id",   limit: 4
    t.integer  "high_score",  limit: 4
    t.integer  "diamonds",    limit: 4
    t.float    "ranking",     limit: 24
    t.boolean  "attempted"
    t.integer  "proficiency", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "user_entity_scores", ["entity_id"], name: "index_user_entity_scores_on_entity_id", using: :btree
  add_index "user_entity_scores", ["entity_name"], name: "index_user_entity_scores_on_entity_name", using: :btree
  add_index "user_entity_scores", ["user_id"], name: "index_user_entity_scores_on_user_id", using: :btree

  create_table "user_worksheet_attempts", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "topic_id",        limit: 4
    t.integer  "second_topic_id", limit: 4
    t.integer  "score",           limit: 4
    t.integer  "diamonds",        limit: 4
    t.boolean  "attempted"
    t.integer  "proficiency",     limit: 4
    t.boolean  "win"
    t.integer  "defeat_level",    limit: 4
    t.integer  "worksheet_id",    limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "ranking",         limit: 24
  end

  add_index "user_worksheet_attempts", ["second_topic_id"], name: "index_user_worksheet_attempts_on_second_topic_id", using: :btree
  add_index "user_worksheet_attempts", ["topic_id"], name: "index_user_worksheet_attempts_on_topic_id", using: :btree
  add_index "user_worksheet_attempts", ["user_id"], name: "index_user_worksheet_attempts_on_user_id", using: :btree
  add_index "user_worksheet_attempts", ["worksheet_id"], name: "index_user_worksheet_attempts_on_worksheet_id", using: :btree

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
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "worksheet_difficulty_levels", force: :cascade do |t|
    t.integer  "difficulty_level_id", limit: 4
    t.integer  "worksheet_id",        limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "worksheet_difficulty_levels", ["difficulty_level_id"], name: "index_worksheet_difficulty_levels_on_difficulty_level_id", using: :btree
  add_index "worksheet_difficulty_levels", ["worksheet_id"], name: "index_worksheet_difficulty_levels_on_worksheet_id", using: :btree

  create_table "worksheet_scqs", force: :cascade do |t|
    t.integer  "short_choice_question_id", limit: 4
    t.integer  "position",                 limit: 4
    t.integer  "worksheet_id",             limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "worksheet_scqs", ["position"], name: "index_worksheet_scqs_on_position", using: :btree
  add_index "worksheet_scqs", ["short_choice_question_id"], name: "index_worksheet_scqs_on_short_choice_question_id", using: :btree
  add_index "worksheet_scqs", ["worksheet_id"], name: "index_worksheet_scqs_on_worksheet_id", using: :btree

  create_table "worksheets", force: :cascade do |t|
    t.integer  "topic_id",        limit: 4
    t.integer  "second_topic_id", limit: 4
    t.boolean  "active"
    t.integer  "difficulty",      limit: 4
    t.integer  "chapter_id",      limit: 4
    t.integer  "stream_id",       limit: 4
    t.integer  "standard_id",     limit: 4
    t.integer  "subject_id",      limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "worksheets", ["active"], name: "index_worksheets_on_active", using: :btree
  add_index "worksheets", ["chapter_id"], name: "index_worksheets_on_chapter_id", using: :btree
  add_index "worksheets", ["difficulty"], name: "index_worksheets_on_difficulty", using: :btree
  add_index "worksheets", ["second_topic_id"], name: "index_worksheets_on_second_topic_id", using: :btree
  add_index "worksheets", ["standard_id"], name: "index_worksheets_on_standard_id", using: :btree
  add_index "worksheets", ["stream_id"], name: "index_worksheets_on_stream_id", using: :btree
  add_index "worksheets", ["subject_id"], name: "index_worksheets_on_subject_id", using: :btree
  add_index "worksheets", ["topic_id"], name: "index_worksheets_on_topic_id", using: :btree

end
