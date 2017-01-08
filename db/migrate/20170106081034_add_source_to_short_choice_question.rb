class AddSourceToShortChoiceQuestion < ActiveRecord::Migration
  def change
  	add_column :short_choice_questions, :source_id, :integer
  end
end
