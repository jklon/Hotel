class AddPersonalizationTestTypeToDiagnosticTest < ActiveRecord::Migration
  def change
  	add_column :diagnostic_tests, :test_type, :string
  	add_column :diagnostic_tests, :diagnostic_test_personalization_id, :integer
  	add_column :diagnostic_tests, :personalization_type, :integer
  end
end
