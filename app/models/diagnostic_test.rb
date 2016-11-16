class DiagnosticTest < ActiveRecord::Base
  belongs_to :standard
  belongs_to :subject
  has_many :diagnostic_test_questions
  has_many :short_choice_questions, :through => :diagnostic_test_questions,
   :source => :question, :source_type => "ShortChoiceQuestion"


  def get_member diagnostic_test_params
    DiagnosticTest.includes(:short_choice_questions).find_by_id(diagnostic_test_params[:id])
  end
end
