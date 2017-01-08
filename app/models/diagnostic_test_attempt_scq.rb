class DiagnosticTestAttemptScq < ActiveRecord::Base
  belongs_to :diagnostic_test_attempt
  belongs_to :short_choice_question
  belongs_to :short_choice_answer
  has_many :diagnostic_test_attempt_scq_scas

  has_many :short_choice_answer, :through => :diagnostic_test_attempt_scq_scas

end
