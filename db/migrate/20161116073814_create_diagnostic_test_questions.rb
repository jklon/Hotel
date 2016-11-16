class CreateDiagnosticTestQuestions < ActiveRecord::Migration
  def change
    create_table :diagnostic_test_questions do |t|
      t.string :question_type
      t.integer :question_id
      t.integer :diagnostic_test_id

      t.timestamps null: false
    end
  end
end
