class AddQuestionWorksheetScqs < ActiveRecord::Migration
  def change
    change_table :worksheet_scqs do |t|
      t.references :question, :polymorphic => true
    end
  end
end
