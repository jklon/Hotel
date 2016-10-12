class CreateSubTopics < ActiveRecord::Migration
  def change
    create_table :sub_topics do |t|
      t.string :name
      t.integer :subtopic_number
      t.integer :subject_id
      t.integer :standard_id
      t.integer :class_id
      t.integer :chapter_id
      t.integer :topic_id

      t.timestamps null: false
    end
  end
end
