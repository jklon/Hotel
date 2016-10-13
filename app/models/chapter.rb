class Chapter < ActiveRecord::Base
  belongs_to :subject
  belongs_to :standard
  belongs_to :stream
  has_many :topics
  has_many :sub_topics
  validates :name, uniqueness: true, presence: true
end

