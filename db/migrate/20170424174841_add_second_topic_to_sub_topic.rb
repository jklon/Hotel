class AddSecondTopicToSubTopic < ActiveRecord::Migration
  def change
    add_reference :sub_topics, :second_topic, index: true, foreign_key: true
  end
end
