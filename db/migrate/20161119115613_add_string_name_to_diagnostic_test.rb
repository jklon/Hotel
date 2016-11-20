class AddStringNameToDiagnosticTest < ActiveRecord::Migration
  def change
    add_column :diagnostic_tests, :string_name, :string
  end
end
