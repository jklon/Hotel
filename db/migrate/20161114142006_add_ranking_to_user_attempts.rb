class AddRankingToUserAttempts < ActiveRecord::Migration
  def change
    add_column :user_worksheet_attempts, :ranking, :float
  end
end
