class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :full_name
      t.integer :standard_id
      t.text :description

      t.timestamps null: false
    end
  end
end
