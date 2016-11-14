class Stream < ActiveRecord::Base
  has_many :chapters
  has_many :topics
  has_many :second_topics
  has_many :user_scores, as: :entity
end
