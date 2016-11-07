class AddTopicIdToEmq < ActiveRecord::Migration
  def change
    add_column :extra_marks_questions, :topic_id, :integer
  end
end
