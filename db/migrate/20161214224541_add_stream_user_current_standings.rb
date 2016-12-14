class AddStreamUserCurrentStandings < ActiveRecord::Migration
  def change
    add_column :user_current_standings, :stream_id, :integer
  end
end
