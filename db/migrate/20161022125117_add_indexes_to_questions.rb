class AddIndexesToQuestions < ActiveRecord::Migration
  def change
    add_index :short_choice_questions, :level
  end
end
