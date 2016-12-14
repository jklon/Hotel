class CreateDifficultywiseWorksheetBreakups < ActiveRecord::Migration
  def change
    create_table :difficultywise_worksheet_breakups do |t|
      t.integer :ques_content
      t.integer :difficulty_level_id, limit: 4
      t.integer :user_worksheet_attempt_id, limit: 4

      t.timestamps null: false
    end
  end
end
