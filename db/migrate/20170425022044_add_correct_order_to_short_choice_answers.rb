class AddCorrectOrderToShortChoiceAnswers < ActiveRecord::Migration
  def change
    add_column :short_choice_answers, :correct_order, :integer
  end
end
