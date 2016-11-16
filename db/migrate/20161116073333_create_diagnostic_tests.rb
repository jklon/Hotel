class CreateDiagnosticTests < ActiveRecord::Migration
  def change
    create_table :diagnostic_tests do |t|
      t.integer :standard_id
      t.integer :subject_id
      t.string :name

      t.timestamps null: false
    end
  end
end
