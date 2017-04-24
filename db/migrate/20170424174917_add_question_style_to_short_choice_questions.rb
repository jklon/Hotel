class AddQuestionStyleToShortChoiceQuestions < ActiveRecord::Migration
  def change
    add_reference :short_choice_questions, :question_style, index: true, foreign_key: true
  end
end
