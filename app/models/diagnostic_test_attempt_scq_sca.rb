class DiagnosticTestAttemptScqSca < ActiveRecord::Base
  belongs_to :diagnostic_test_attempt_scq
  belongs_to :short_choice_answer
end
