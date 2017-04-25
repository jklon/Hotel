class Worksheet < ActiveRecord::Base
  belongs_to :standard
  belongs_to :subject
  belongs_to :stream
  belongs_to :second_topic
  belongs_to :chapter
  belongs_to :sub_topic
  belongs_to :question_style
  has_many :worksheet_scqs
  has_many :worksheet_questions
  has_many :worksheet_attempts
  has_many :difficultywise_worksheet_breakup
  has_many :users, through: :user_worksheet_attempts
  has_many :short_choice_questions, :through => :worksheet_questions,
   :source => :question, :source_type => "ShortChoiceQuestion"

  def self.evaluate_test question_answers

  end
end
