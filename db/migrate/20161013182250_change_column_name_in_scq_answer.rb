class ChangeColumnNameInScqAnswer < ActiveRecord::Migration
  def change
    rename_column :short_choice_answers, :question_id, :short_choice_question_id
  end
end
