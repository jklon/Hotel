class DiagnosticTest < ActiveRecord::Base
  belongs_to :standard
  belongs_to :subject
  has_many :questions, :through => :daignostic_test_questions
end
