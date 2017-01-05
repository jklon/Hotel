class CreateUserCurrentStandings < ActiveRecord::Migration
  def change
    create_table :user_current_standings do |t|
      t.string :entity_type
      t.integer :entity_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
