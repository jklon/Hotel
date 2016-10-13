class Standard < ActiveRecord::Base
  has_many :subjects
  has_many :chapters
  has_many :topics
  has_many :sub_topics
end
