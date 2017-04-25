class AddWorksheetSequenceNoToShortChoiceQuestions < ActiveRecord::Migration
  def change
    add_column :short_choice_questions, :worksheet_sequence_no, :integer
  end
end
