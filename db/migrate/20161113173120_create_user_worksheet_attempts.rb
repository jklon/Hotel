class CreateUserWorksheetAttempts < ActiveRecord::Migration
  def change
    create_table :user_worksheet_attempts do |t|
      t.integer :user_id
      t.integer :topic_id
      t.integer :second_topic_id
      t.integer :score
      t.integer :diamonds
      t.boolean :attempted
      t.integer :proficiency
      t.boolean :win
      t.integer :defeat_level
      t.integer :worksheet_id

      t.timestamps null: false
    end

    add_index :user_worksheet_attempts, :user_id
    add_index :user_worksheet_attempts, :topic_id
    add_index :user_worksheet_attempts, :second_topic_id
    add_index :user_worksheet_attempts, :worksheet_id
  end
end

