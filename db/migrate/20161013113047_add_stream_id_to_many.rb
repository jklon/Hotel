class AddStreamIdToMany < ActiveRecord::Migration
  def change
    add_column :chapters, :stream_id, :integer
    add_column :topics, :stream_id, :integer
    add_column :sub_topics, :stream_id, :integer
    add_index :chapters, :stream_id
    add_index :topics, :stream_id
    add_index :sub_topics, :stream_id
  end
end
