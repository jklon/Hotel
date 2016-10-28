class AddEmAnswerIdToExtraMarksAnswer < ActiveRecord::Migration
  def change
    add_column :extra_marks_answers, :em_answer_id, :integer
  end
end
