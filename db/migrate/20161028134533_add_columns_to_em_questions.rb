class AddColumnsToEmQuestions < ActiveRecord::Migration
  def change
    add_column :extra_marks_questions, :standard_id, :integer
    add_column :extra_marks_questions, :chapter_id, :integer
    add_column :extra_marks_questions, :subject_id, :integer

    add_index :extra_marks_questions, :standard_id
    add_index :extra_marks_questions, :chapter_id
    add_index :extra_marks_questions, :subject_id
  end
end
