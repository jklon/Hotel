class DiagnosticTest < ActiveRecord::Base
  belongs_to :standard
  belongs_to :subject
  has_many :diagnostic_test_questions
  has_many :short_choice_questions, :through => :diagnostic_test_questions,
   :source => :question, :source_type => "ShortChoiceQuestion"
end
