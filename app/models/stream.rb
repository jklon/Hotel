class Stream < ActiveRecord::Base
  has_many :chapters
  has_many :topics
  has_many :second_topics
end
