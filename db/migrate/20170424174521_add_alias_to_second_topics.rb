class AddAliasToSecondTopics < ActiveRecord::Migration
  def change
    add_column :second_topics, :alias, :string
    add_column :second_topics, :sequence, :integer
  end
end
