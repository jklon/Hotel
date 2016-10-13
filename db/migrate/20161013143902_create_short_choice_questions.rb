class CreateShortChoiceQuestions < ActiveRecord::Migration
  def change
    create_table :short_choice_questions do |t|
      t.text :question_text
      t.text :hint_text
      t.text :answer_description
      t.integer :sub_topic_id
      t.integer :topic_id
      t.integer :chapter_id
      t.integer :stream_id
      t.integer :subject_id
      t.integer :standard_id

      t.timestamps null: false
    end

    add_index :short_choice_questions, :topic_id
    add_index :short_choice_questions, :sub_topic_id
    add_index :short_choice_questions, :chapter_id
    add_index :short_choice_questions, :stream_id
    add_index :short_choice_questions, :subject_id
    add_index :short_choice_questions, :standard_id
  end
end
