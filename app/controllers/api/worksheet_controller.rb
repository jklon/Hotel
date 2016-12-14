class Api::WorksheetController < ApiController
  skip_before_action :authenticate_user!
  protect_from_forgery :except => :worksheet_attempt
  def get_worksheet
  	
    @worksheet = Worksheet.includes(short_choice_questions: [:short_choice_answers]).where(:id => params[:worksheet_id]).first
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
