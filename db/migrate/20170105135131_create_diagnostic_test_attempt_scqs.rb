class CreateDiagnosticTestAttemptScqs < ActiveRecord::Migration
  def change
    create_table :diagnostic_test_attempt_scqs do |t|
      t.integer :diagnostic_test_attempt_id
      t.integer :short_choice_question_id
      t.integer :short_choice_answer_id
      t.float :time_spent
      t.integer :attempt
      t.timestamps null: false

    end

    add_index :diagnostic_test_attempt_scqs, :diagnostic_test_attempt_id
    add_index :diagnostic_test_attempt_scqs, :short_choice_question_id
  end
end
