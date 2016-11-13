class CreateProficiencyLevels < ActiveRecord::Migration
  def change
    create_table :proficiency_levels do |t|
      t.string :name
      t.integer :value

      t.timestamps null: false
    end
  end
end
