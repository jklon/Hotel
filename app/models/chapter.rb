class Chapter < ActiveRecord::Base
  belongs_to :subject
  belongs_to :standard
  belongs_to :stream
  has_many :topics
  has_many :sub_topics
  validates :name, presence: true
  has_many :short_choice_questions
  has_many :extra_marks_questions
end

