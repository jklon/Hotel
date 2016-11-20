class CreateDiagnosticTestAttempts < ActiveRecord::Migration
  def change
    create_table :diagnostic_test_attempts do |t|
      t.integer :user_id
      t.integer :diagnostic_test_id

      t.timestamps null: false
    end

    add_index :diagnostic_test_attempts, :diagnostic_test_id
    add_index :diagnostic_test_attempts, :user_id
  end
end
