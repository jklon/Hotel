class DiagnosticTestAttemptsController < ApplicationController
  before_action :load_the_attempt, only: [:show]
  def index
    @filterrific = initialize_filterrific(
      DiagnosticTestAttempt,
      params[:filterrific]
    ) or return
    @diagnostic_test_attempts = @filterrific.find.paginate(:page => params[:page], :per_page => 10)
  end

  def show
  end

  private
  def load_the_attempt
    @dta = DiagnosticTestAttempt.includes(diagnostic_test_attempt_scqs: [:short_choice_question,
     diagnostic_test_attempt_scq_scas: [:short_choice_answer]]).find(params[:id])
  end
end
