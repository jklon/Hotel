class CreateWorksheetQuestions < ActiveRecord::Migration
  def change
    create_table :worksheet_questions do |t|
      t.integer :question_id
      t.string :question_type
      t.integer :sequence_no
      t.references :worksheet, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
