class CreateQuestionStyles < ActiveRecord::Migration
  def change
    create_table :question_styles do |t|
      t.string :name
      t.string :alias

      t.timestamps null: false
    end
  end
end
