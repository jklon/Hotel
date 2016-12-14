class Stream < ActiveRecord::Base
  has_many :chapters
  has_many :topics
  has_many :second_topics
  has_many :user_entity_scores, as: :entity

  def lowest_topic_id
    self.second_topics.first.id
  end

  def lowest_topic
    self.second_topics.first
  end
end
