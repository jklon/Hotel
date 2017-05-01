class AddCorrectMultipleToShortChoiceAnswers < ActiveRecord::Migration
  def change
    add_column :short_choice_answers, :correct_multiple, :integer
  end
end
