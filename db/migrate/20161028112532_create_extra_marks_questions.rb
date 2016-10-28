class CreateExtraMarksQuestions < ActiveRecord::Migration
  def change
    create_table  :extra_marks_questions do |t|
      t.integer   :em_question_id
      t.text      :question_text
      t.string    :question_type
      t.text      :answer_description
      t.string    :difficulty
      t.integer   :level
      t.string    :answer_type

      t.timestamps null: false
    end

    add_index :extra_marks_questions, :em_question_id
    add_index :extra_marks_questions, :level
  end
end
