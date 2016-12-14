class Api::WorksheetController < ApiController
  skip_before_action :authenticate_user!
  protect_from_forgery :except => :worksheet_attempt
  protect_from_forgery :except => :get_worksheet

  
  def get_intro
  	user_params_sane? params[:user]
    @user = User.find_or_create_temp_user(params[:user])

    #Creating empty JSON to return for return
    result ={}
    attempt = UserWorksheetAttempt.where(:user => @user,:worksheet_id => params[:worksheet_id]).last
    if (attempt)
      #render json: result.to_json, status: 200 and return
      
      @worksheet_attempt = UserWorksheetAttempt.where(:user => @user,:worksheet_id => params[:worksheet_id]).last
    else
      
    end
    @worksheet = Worksheet.includes(short_choice_questions: [:short_choice_answers]).where(:id => params[:worksheet_id]).first
    #trial_worksheet = Worksheet.where(:id => params[:worksheet_id]).first
    @subject = @worksheet.subject
    
  end

  def get_worksheet
  	user_params_sane? params[:user]
    @user = User.find_or_create_temp_user(params[:user])

    #Creating empty JSON to return for return
    result ={}
    attempt = UserWorksheetAttempt.where(:user => @user,:worksheet_id => params[:worksheet_id]).last
    if (attempt)
      #render json: result.to_json, status: 200 and return
      @worksheet = Worksheet.includes(short_choice_questions: [:short_choice_answers]).where(:id => params[:worksheet_id]).first
      @worksheet_attempt = UserWorksheetAttempt.where(:user => @user,:worksheet_id => params[:worksheet_id]).last
    else
      @worksheet = Worksheet.includes(short_choice_questions: [:short_choice_answers]).where(:id => params[:worksheet_id]).first
    end
  end
  
  def worksheet_attempt
  	user_params_sane? params[:user]
    @user = User.find_or_create_temp_user(params[:user])

    #Creating empty JSON to return for return
    result ={}
    
    #Finding SecondTopic from Worksheet model
    second_topic = Worksheet.where(:id => params[:worksheet][:id]).first.second_topic_id
    
    #Creating UserWorksheetAttempt object
    attempt = UserWorksheetAttempt.create!(:user => @user, :worksheet_id => params[:worksheet][:id],:second_topic_id => second_topic, :score => params[:worksheet][:score], :diamonds => params[:worksheet][:diamonds], :attempted => params[:worksheet][:attempted], :proficiency => params[:worksheet][:proficiency], :win => params[:worksheet][:win], :defeat_level => params[:worksheet][:defeat_level])
    DifficultyLevel.where(:value => (params[:worksheet][:difficultywise_breakup]).keys).each do |level|
      DifficultywiseWorksheetBreakup.create!(:difficulty_level_id => level.id, :user_worksheet_attempt_id => attempt.id, :ques_content =>params[:worksheet][:difficultywise_breakup][level.id.to_s]['content'])
  	end
  	
  	render json: result.to_json, status: 200 and return
  end
end
