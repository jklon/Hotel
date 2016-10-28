class CreateExtraMarksAnswers < ActiveRecord::Migration
  def change
    create_table :extra_marks_answers do |t|
      t.integer :extra_marks_question_id
      t.boolean :correct
      t.text    :answer_text
      t.string  :label

      t.timestamps null: false
    end

    add_index :extra_marks_answers, :extra_marks_question_id
  end
end
