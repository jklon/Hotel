class Subject < ActiveRecord::Base
  belongs_to :standard
  has_many :chapters
  has_many :topics
  has_many :second_topics
  has_many :sub_topics
  has_many :extra_marks_questions
  has_many :short_choice_questions
end
