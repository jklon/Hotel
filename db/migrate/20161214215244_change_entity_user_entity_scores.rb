class ChangeEntityUserEntityScores < ActiveRecord::Migration
  def change
  	rename_column :user_entity_scores, :entity_name, :entity_type
  end
end
