class RenameColumnShortChoiceQuestionsQuestionStyle < ActiveRecord::Migration
  def change
  	rename_column :short_choice_questions, :question_style, :question_style_old
  end
end
