class AddOldQuestionTextToScq < ActiveRecord::Migration
  def change
    add_column :short_choice_questions, :question_text_old, :text
    add_column :short_choice_answers, :answer_text_old, :text
  end
end
