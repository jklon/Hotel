class CreateUserEntityScores < ActiveRecord::Migration
  def change
    create_table :user_entity_scores do |t|
      t.integer :user_id
      t.string :entity_name
      t.integer :entity_id
      t.integer :high_score
      t.integer :diamonds
      t.float :ranking
      t.boolean :attempted
      t.integer :proficiency

      t.timestamps null: false
    end

    add_index :user_entity_scores, :user_id
    add_index :user_entity_scores, :entity_id
    add_index :user_entity_scores, :entity_name
  end
end
