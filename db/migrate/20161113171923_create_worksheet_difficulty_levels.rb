class CreateWorksheetDifficultyLevels < ActiveRecord::Migration
  def change
    create_table :worksheet_difficulty_levels do |t|
      t.integer :difficulty_level_id
      t.integer :worksheet_id

      t.timestamps null: false
    end

    add_index :worksheet_difficulty_levels, :difficulty_level_id
    add_index :worksheet_difficulty_levels, :worksheet_id
  end
end
