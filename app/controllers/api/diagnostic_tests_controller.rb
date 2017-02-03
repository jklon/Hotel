class Api::DiagnosticTestsController < ApiController
  skip_before_action :authenticate_user!
  protect_from_forgery :except => :test_attempt
  protect_from_forgery :except => :get_attempt_details

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
      if params[:stream_id]
        @diagnostic_test = DiagnosticTest.includes(short_choice_questions: [:short_choice_answers])
        .where(:standard_id => params[:standard_id], :subject_id => params[:subject_id],
          :personalization_type => 0,:entity_type => "Stream",:entity_id => params[:stream_id].to_i)[params[:diagnostic_test].to_i-1]
      else
        @diagnostic_test = DiagnosticTest.includes(short_choice_questions: [:short_choice_answers])
        .where(:standard_id => params[:standard_id], :subject_id => params[:subject_id],
          :personalization_type => 0)[params[:diagnostic_test].to_i-1]
      end
    end
  end

  def get_attempt_details
    response ={}
    attempted =  0
    response["attempted"]||={}
    personalized = 0
    response["personalized"]||={}
    number = UserPhoneNumber.find_by_number(params[:number])
    if number
      @user = number.user
      ##Getting User Details
      user_number = params[:number]
      last_test_attempt = DiagnosticTestAttempt.where(:user_id => @user.id).last

      ##Setting Attempted Flag
      attempted = 1 if last_test_attempt
      response["attempted"]["comment"] = "Hi, "+@user.first_name+", You last attempted test on "+last_test_attempt.created_at.to_s if last_test_attempt

      ##Setting Personalized flag
      general_test_attempt = DiagnosticTestAttempt.where(:user_id => @user.id).joins(:diagnostic_test).where("diagnostic_tests.personalization_type = 0").last
      personalized = DiagnosticTestPersonalization.where(:user=> @user,:attempted => false).count if general_test_attempt
      if personalized>0
        response["standards"]||={}
        response["standards"]["standard_id"]= general_test_attempt.diagnostic_test.standard.id
        response["standards"]["standard_number"] = general_test_attempt.diagnostic_test.standard.standard_number
        response["standards"]["name"] = general_test_attempt.diagnostic_test.standard.name
        response["personalized"]["comment"] = "Hi, "+@user.first_name+", We have got a special test based on the result of your last test at "+general_test_attempt.created_at.to_s
      end
    end
    
    if personalized == 0
      response = get_general_tests_with_subjects(response)
    end
    response["attempted"]["flag"] = attempted
    response["personalized"]["count"] = personalized
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
  def get_general_tests(response)
    response["standards"] = []
    Standard.includes(:subjects).where(:standard_number => [6,7,8,9]).each do |standard|
      payload ={}
      payload["standard_id"] = standard.id
      payload["subject_id"] = standard.id
      payload["standard_number"] = standard.standard_number
      payload["name"] = standard.name
      payload["streams"]=[]
      DiagnosticTest.where(:personalization_type => 0,:standard_id => standard.id,:entity_type => "Stream").each do |test|
        stream = Stream.where(:id => test.entity_id).first
        if stream
          stream_payload = {}
          stream_payload["name"] = stream.name 
          stream_payload["id"] = stream.id
          payload["streams"] << stream_payload
        end
      end
      response["standards"]<< payload
    end
    return response
  end
  def get_general_tests_with_subjects(response)
    response["standards"]||={}
    Standard.includes(:subjects).where(:standard_number => [6,7,8,9]).each do |standard|
      response["standards"][standard.id]||={}
      response["standards"][standard.id]["name"]=standard.name
      response["standards"][standard.id]["number"]=standard.standard_number
      response["standards"][standard.id]["subjects"]||={}
      DiagnosticTest.where(:personalization_type => 0,:standard_id => standard.id,:entity_type => "Stream").each do |test|
        subject= Subject.where(:id => test.subject_id).first
        if subject
          response["standards"][standard.id]["subjects"][subject.id]||={}
          response["standards"][standard.id]["subjects"][subject.id]["name"]=subject.name
          response["standards"][standard.id]["subjects"][subject.id]["streams"]||={}
          stream = Stream.where(:id => test.entity_id).first
          if stream
            response["standards"][standard.id]["subjects"][subject.id]["streams"][stream.id]||={}
            response["standards"][standard.id]["subjects"][subject.id]["streams"][stream.id]["name"]=stream.name
          end
        end
      end

    end
    return response
  end

end