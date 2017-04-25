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

    #Creating empty JSON to return for return
    result ={}
    attempt = UserWorksheetAttempt.where(:user => @user,:worksheet_id => params[:worksheet_id]).last
    if (false)
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
    topic = SecondTopic.where(:id => second_topic).first

    userChapterScore = UserEntityScore.where(:user => @user, :entity_type => 'Chapter', :entity_id =>topic.chapter_id).first
    if (userChapterScore)
      userChapterScore.update_columns(:high_score=>attempt.score, :diamonds=>attempt.diamonds,:attempted=>attempt.attempted,:proficiency=>attempt.proficiency)
      userChapterScore.save!
    else
      UserEntityScore.create!(:user => @user, :entity_type => 'Chapter', :entity_id =>topic.chapter_id, :high_score=>attempt.score, :diamonds=>attempt.diamonds,:attempted=>attempt.attempted,:proficiency=>attempt.proficiency)
    end

    userTopicScore = UserEntityScore.where(:user => @user, :entity_type => 'SecondTopic', :entity_id =>topic.id).first
    if (userTopicScore)
      userTopicScore.update_columns(:high_score=>attempt.score, :diamonds=>attempt.diamonds,:attempted=>attempt.attempted,:proficiency=>attempt.proficiency)
      userTopicScore.save!
    else
      UserEntityScore.create!(:user => @user, :entity_type => 'SecondTopic', :entity_id =>topic.id, :high_score=>attempt.score, :diamonds=>attempt.diamonds,:attempted=>attempt.attempted,:proficiency=>attempt.proficiency)
    end

    userStreamScore = UserEntityScore.where(:user => @user, :entity_type => 'Stream', :entity_id =>topic.stream_id).first
    if (userStreamScore)
      userStreamScore.update_columns(:high_score=>attempt.score, :diamonds=>attempt.diamonds,:attempted=>attempt.attempted,:proficiency=>attempt.proficiency)
      userStreamScore.save!
    else
      UserEntityScore.create!(:user => @user, :entity_type => 'Stream', :entity_id =>topic.stream_id, :high_score=>attempt.score, :diamonds=>attempt.diamonds,:attempted=>attempt.attempted,:proficiency=>attempt.proficiency)
    end
    
  	
  	render json: result.to_json, status: 200 and return
  end
end
