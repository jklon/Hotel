class CreateSecondTopicTrees < ActiveRecord::Migration
  def change
    create_table :second_topic_trees do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps null: false
    end
    add_index :second_topic_trees, :parent_id
    add_index :second_topic_trees, :child_id
  end
end
