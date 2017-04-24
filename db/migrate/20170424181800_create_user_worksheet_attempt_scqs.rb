class CreateUserWorksheetAttemptScqs < ActiveRecord::Migration
  def change
    create_table :user_worksheet_attempt_scqs do |t|
      t.references :short_choice_question, index: {:name => 'index_user_ws_attempt_scq_scq_id'}, foreign_key: true
      t.references :user_worksheet_attempt, index: {:name => 'index_user_ws_attempt_scq_ws_attempt_id'}, foreign_key: true
      t.float :time_spent
      t.integer :attempt
      t.timestamps null: false
    end
  end
end
