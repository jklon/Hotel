class Topic < ActiveRecord::Base
  belongs_to :subject
  belongs_to :standard
  belongs_to :chapter
  has_many :sub_topics
end
