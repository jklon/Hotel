class Worksheet < ActiveRecord::Base
  belongs_to :standard
  belongs_to :subject
  belongs_to :stream
  belongs_to :second_topic
  has_many :worksheet_scqs
  has_many :worksheet_attempts
  has_many :difficultywise_worksheet_breakup
  has_many :users, through: :user_worksheet_attempts
  has_many :short_choice_questions, :through => :worksheet_scqs,
   :source => :question, :source_type => "ShortChoiceQuestion"

  def self.evaluate_test question_answers

  end
end
