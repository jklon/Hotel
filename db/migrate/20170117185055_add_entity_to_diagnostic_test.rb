class AddEntityToDiagnosticTest < ActiveRecord::Migration
  def change
  	add_column :diagnostic_tests, :entity_id, :integer
  	add_column :diagnostic_tests, :entity_type, :string
  end
end
