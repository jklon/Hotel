class Stream < ActiveRecord::Base
  has_many :chapters
  has_many :topics
end
