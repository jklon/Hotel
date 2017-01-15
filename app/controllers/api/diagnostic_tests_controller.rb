class Api::DiagnosticTestsController < ApiController
  skip_before_action :authenticate_user!
  protect_from_forgery :except => :test_attempt

  def get_test
    personalized = 0
    if params[:personalization_type]=="1"
      puts "inside personalized section"
      user = UserPhoneNumber.find_by_number(params[:number]).user
      personalized_test = DiagnosticTestPersonalization.where(:user=> user,:attempted => false).first
      if personalized_test
        @diagnostic_test = DiagnosticTest.includes(short_choice_questions: [:short_choice_answers])
        .where(:standard_id => params[:standard_id],:diagnostic_test_personalization_id => personalized_test.id, 
          :personalization_type => 1, :subject_id => params[:subject_id]).first
        personalized = 1
      end
    end
    if personalized ==0
      @diagnostic_test = DiagnosticTest.includes(short_choice_questions: [:short_choice_answers])
      .where(:standard_id => params[:standard_id], :subject_id => params[:subject_id],
        :personalization_type => 0)[params[:diagnostic_test].to_i-1]
    end
  end

  def get_attempt_details
    response ={}
    attempted =  0
    response["attempted"]||={}
    personalized = 0
    response["personalized"]||={}

    user_number = UserPhoneNumber.find_by_number(params[:number])
    if user_number 
      ##Getting User Details
      @user = user_number.user
      test_attempt = DiagnosticTestAttempt.where(:user_id => @user.id).last

      ##Setting Attempted Flag
      attempted = 1 if test_attempt
      response["attempted"]["comment"] = "Hi, "+@user.first_name+", You last attempted test on "+test_attempt.created_at.to_s if test_attempt

      ##Setting Personalized flag
      personalized = test_attempt.generate_personalized_test(@user,test_attempt,true)["personalized"] if test_attempt
      if personalized  ==1
        response["standards"]||={}
        response["standards"]["standard_id"]= test_attempt.diagnostic_test.standard.id
        response["standards"]["subject_id"] = test_attempt.diagnostic_test.standard.id
        response["standards"]["standard_number"] = test_attempt.diagnostic_test.standard.standard_number
        response["standards"]["name"] = test_attempt.diagnostic_test.standard.name
        response["personalized"]["comment"] = "Hi, "+@user.first_name+", We have got a special test based on the result of your last test at "+test_attempt.created_at.to_s
      end
    end
    
    if personalized == 0
      response["standards"] = []
      Standard.includes(:subjects).where(:standard_number => [6,7]).each do |standard|
        payload ={}
        payload["standard_id"] = standard.id
        payload["subject_id"] = standard.id
        payload["standard_number"] = standard.standard_number
        payload["name"] = standard.name
        response["standards"]<< payload
      end
    end
    response["attempted"]["flag"] = attempted
    response["personalized"]["flag"] = personalized
    render json: response.to_json, status: 200
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