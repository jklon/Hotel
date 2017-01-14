class CreateDiagnosticTestPersonalizations < ActiveRecord::Migration
  def change
    create_table :diagnostic_test_personalizations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :diagnostic_test, index: true, foreign_key: true
      t.boolean :attempted

      t.timestamps null: false
    end
  end
end
