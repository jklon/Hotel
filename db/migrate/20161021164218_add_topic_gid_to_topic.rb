class AddTopicGidToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :goal_tid, :integer
    add_column :topics, :description, :string
  end
end
