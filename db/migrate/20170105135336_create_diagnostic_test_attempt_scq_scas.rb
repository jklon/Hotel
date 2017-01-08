class CreateDiagnosticTestAttemptScqScas < ActiveRecord::Migration
  def change
    create_table :diagnostic_test_attempt_scq_scas do |t|
      t.integer :diagnostic_test_attempt_scq_id
      t.integer :short_choice_answer_id
      t.float :time_spent
      t.integer :attempt_order
      t.timestamps null: false
    end
  end
end
