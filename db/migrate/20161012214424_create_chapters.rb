class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :name
      t.integer :chapter_number
      t.integer :subject_id
      t.integer :standard_id
      t.integer :class_id

      t.timestamps null: false
    end
  end
end
