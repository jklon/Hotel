class AddReferenceColumnsToScq < ActiveRecord::Migration
  def change
    add_column :short_choice_questions, :reference_solving_time, :integer
    add_column :short_choice_questions, :include_in_diagnostic_test, :boolean
  end
end
