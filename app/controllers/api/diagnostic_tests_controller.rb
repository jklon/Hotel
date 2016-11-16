class Api::DiagnosticTestsController < ApiController
  
  def get_test
    @diagnostic_test = DiagnosticTest.includes(short_choice_questions: [:short_choice_answers]).find(params[:id])
  end

  private

  def diagnostic_test_params
    params.require(:diagnostic_test).permit(:id, :name, :standard_id)
  end

end