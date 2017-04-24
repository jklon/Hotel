class CreateUserWorksheetAttemptScqScas < ActiveRecord::Migration
  def change
    create_table :user_worksheet_attempt_scq_scas do |t|
      t.references :short_choice_answer, index: {:name =>'index_user_ws_attempt_scq_sca_sca_id'}, foreign_key: true
      t.references :user_worksheet_attempt_scq, index: {:name =>'index_user_ws_attempt_scq_sca_ws_attempt_id'}, foreign_key: true
      t.float :time_spent
      t.integer :attempt_order
      t.timestamps null: false
    end
  end
end
