class AddQuestionStyleSequenceEntitySubTopicToWorksheet < ActiveRecord::Migration
  def change
  	add_reference :worksheets, :question_style, index: true, foreign_key: true
	add_column :worksheets, :sequence, :integer
	add_reference :worksheets, :sub_topic, index: true, foreign_key: true
	add_column :worksheets, :entity_id, :integer
	add_column :worksheets, :entity_type, :string
  end
end
