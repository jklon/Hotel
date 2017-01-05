class Api::HomepageController < ApiController

  skip_before_action :authenticate_user!
  protect_from_forgery :except => :get_streamwise_score
  protect_from_forgery :except => :get_streamwise_score_short


  def get_streamwise_score
  	user_params_sane? params[:user]
    @user = User.find_or_create_temp_user(params[:user])

    @stream = Stream.all;
  end

  def get_streamwise_score_short 
  	stream_hash = {}
    stream_hash["streams"]=[]
    Stream.all.each do |stream|
      
      #Calculating stream score
      stream_score = UserEntityScore.where(:user =>@user, :entity_type => "Stream", :entity_id => stream.id).first
      stream_score_value ={}
      stream_score_value = {'score'=>stream_score.high_score,'diamonds'=>stream_score.diamonds, 'proficiency'=>stream_score.proficiency} if(stream_score)
	  
      #Creating stream object
	  stream_element = {'id'=>stream.id,'name'=>stream.name,'scorecard'=>stream_score_value, 'topics'=> []}
	  current_topic = UserCurrentStanding.where(:stream_id=>stream.id, :user_id => 4,:entity_type => "SecondTopic").first
	  
	  #If this stream was ever attempted by user
	  if(current_topic)
	    SecondTopic.where(:stream_id=>stream.id).where("id > ?", current_topic.entity_id).order(:id).limit(4).each do |topic|
	  	  
	      #Calculating topic score
	  	  topic_score = UserEntityScore.where(:user =>@user, :entity_type => "Stream", :entity_id => stream.id).first
          topic_score_value ={}
          topic_score_value = {'score'=>stream_score.high_score,'diamonds'=>stream_score.diamonds, 'proficiency'=>stream_score.proficiency} if(topic_score)
	      
          #Creating topic object
	      topic_element = {'id'=>topic.id,'name'=>topic.name,'scorecard'=>topic_score_value}
	  	  stream_element["topics"].push(topic_element);
	    end
	    
	    #Stream object created, pushing into array
	    stream_hash["streams"].push(stream_element)
	  end
	end
	puts stream_hash.to_json
	render json: stream_hash.to_json, status: 200
  end
end
