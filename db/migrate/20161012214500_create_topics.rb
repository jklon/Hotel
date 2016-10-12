class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.integer :topic_number
      t.integer :subject_id
      t.integer :standard_id
      t.integer :class_id
      t.integer :chapter_id

      t.timestamps null: false
    end
  end
end
