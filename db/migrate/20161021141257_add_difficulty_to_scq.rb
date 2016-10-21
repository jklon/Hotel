class AddDifficultyToScq < ActiveRecord::Migration
  def change
    add_column :short_choice_questions, :difficulty, :string
  end
end
