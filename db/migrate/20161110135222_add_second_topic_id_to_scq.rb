class AddSecondTopicIdToScq < ActiveRecord::Migration
  def change
    add_column :short_choice_questions, :second_topic_id, :integer
    add_index  :short_choice_questions, :second_topic_id
  end
end
