class ExtraMarksQuestion < ActiveRecord::Base
  has_many :extra_marks_answers
  belongs_to :chapter
  belongs_to :topic
  belongs_to :standard
  belongs_to :topic
end
