class CreateWorksheetScqs < ActiveRecord::Migration
  def change
    create_table :worksheet_scqs do |t|
      t.integer :short_choice_question_id
      t.integer :position
      t.integer :worksheet_id

      t.timestamps null: false
    end

    add_index :worksheet_scqs, :position
    add_index :worksheet_scqs, :worksheet_id
    add_index :worksheet_scqs, :short_choice_question_id
  end
end
