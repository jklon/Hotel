class ShortChoiceQuestion < ActiveRecord::Base
  has_many :short_choice_answers
  belongs_to :subject
  belongs_to :standard
  belongs_to :chapter
  belongs_to :topic
  belongs_to :stream
  belongs_to :sub_topic
end
