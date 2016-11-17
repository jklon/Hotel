class Api::DiagnosticTestsController < ApiController
  skip_before_action :authenticate_user!

  def get_test
    @diagnostic_test = DiagnosticTest.includes(short_choice_questions: [:short_choice_answers])
    .where(:standard_id => params[:standard_id], :subject_id => params[:subject_id]).first
  end

  private

  def diagnostic_test_params
    params.require(:diagnostic_test).permit(:id, :name, :standard_id)
  end

end