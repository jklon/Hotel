class AddAliasSequenceToSubTopics < ActiveRecord::Migration
  def change
    add_column :sub_topics, :alias, :string
    add_column :sub_topics, :sequence, :integer
  end
end
