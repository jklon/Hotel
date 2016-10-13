class CreateShortChoiceAnswers < ActiveRecord::Migration
  def change
    create_table :short_choice_answers do |t|
      t.text :answer_text
      t.boolean :correct
      t.integer :question_id

      t.timestamps null: false
    end

    add_index :short_choice_answers, :question_id
  end
end
