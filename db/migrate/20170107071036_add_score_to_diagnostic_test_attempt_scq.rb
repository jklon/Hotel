class AddScoreToDiagnosticTestAttemptScq < ActiveRecord::Migration
  def change
  	add_column :diagnostic_test_attempt_scqs, :score, :float
  end
end
