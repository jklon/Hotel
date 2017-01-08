class AddTestTypeToUserEntityScore < ActiveRecord::Migration
  def change
  	add_column :user_entity_scores, :test_type, :string
  	add_column :user_entity_scores, :test_id, :integer
  end
end
