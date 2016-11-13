class CreateSecondTopics < ActiveRecord::Migration
  def change
    create_table :second_topics do |t|
      t.integer :chapter_id
      t.integer :subject_id
      t.integer :standard_id
      t.string :name
      t.integer :stream_id

      t.timestamps null: false
    end

    add_index :second_topics, :subject_id
    add_index :second_topics, :standard_id
    add_index :second_topics, :stream_id
    add_index :second_topics, :chapter_id
  end
end
