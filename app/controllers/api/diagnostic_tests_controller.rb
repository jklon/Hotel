class Api::DiagnosticTestsController < ApiController
  skip_before_action :authenticate_user!
  protect_from_forgery :except => :test_attempt

  def get_test
    @diagnostic_test = DiagnosticTest.includes(short_choice_questions: [:short_choice_answers])
    .where(:standard_id => params[:standard_id], :subject_id => params[:subject_id])[params[:diagnostic_test].to_i-1]
  end

  def test_attempt
    user_params_sane? params[:user]
    @user = User.find_or_create_temp_user(params[:user])
    
    if !(params[:diagnostic_test] and params[:diagnostic_test][:short_choice_questions])
      @errors = {error: "No payload"}
      render 'api/error' and return
    end

    if !params[:diagnostic_test][:id]
      @errors = {error: "No test id"}
      render 'api/error' and return
    end

    attempt = DiagnosticTestAttempt.create!(:user => @user, :diagnostic_test_id => params[:diagnostic_test][:id])
    result = attempt.evaluate_test(params[:diagnostic_test][:short_choice_questions],@user,attempt)
    render json: result.to_json, status: 200
  end

  private

  def diagnostic_test_params
    params.require(:diagnostic_test).permit(:id, :name, :standard_id)
  end

end