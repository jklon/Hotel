class CreateWorksheets < ActiveRecord::Migration
  def change
    create_table :worksheets do |t|
      t.integer :topic_id
      t.integer :second_topic_id
      t.boolean :active
      t.integer :difficulty
      t.integer :chapter_id
      t.integer :stream_id
      t.integer :standard_id
      t.integer :subject_id

      t.timestamps null: false
    end

    add_index :worksheets, :topic_id
    add_index :worksheets, :chapter_id
    add_index :worksheets, :subject_id
    add_index :worksheets, :stream_id
    add_index :worksheets, :standard_id
    add_index :worksheets, :active
    add_index :worksheets, :second_topic_id
    add_index :worksheets, :difficulty
  end
end
