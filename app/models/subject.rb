class Subject < ActiveRecord::Base
  belongs_to :standard
  has_many :chapters
  has_many :topics
  has_many :sub_topics
end
