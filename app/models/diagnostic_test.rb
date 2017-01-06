class DiagnosticTest < ActiveRecord::Base
  belongs_to :standard
  belongs_to :subject
  has_many :diagnostic_test_questions
  has_many :diagnostic_test_attempts
  has_many :users, through: :diagnostic_test_attempts
  has_many :short_choice_questions, :through => :diagnostic_test_questions,
   :source => :question, :source_type => "ShortChoiceQuestion"
  has_many :user_entity_scores, as: :test
  def self.evaluate_test question_answers

  end
end
