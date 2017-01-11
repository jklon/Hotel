ShortChoiceQuestion.where("question_text LIKE ?" , "%Upon arranging the following integers%").each do |q|
	puts q.question_text
	puts q.id
end

question = ShortChoiceQuestion.where("question_text LIKE ?" , "%Upon arranging the following integers%").first

answer = ShortChoiceAnswer.where(:short_choice_question_id => question.id).where(:correct => true).first

score ={}
scoreCount = {}
UserEntityScore.where(:entity_type => "SecondTopic").each do |topic|
	if !score.has_key?(topic.id) # will now return true or false
        score[topic.id] = topic.high_score
        scoreCount[topic.id] = 1
      else
        score[topic.id] += topic.high_score
        scoreCount[topic.id] += 1
      end
end
      

score.sort_by {|_key, value| value}.first(10)

score ={}
scoreCount = {}
UserEntityScore.where(:entity_type => "SecondTopic").where("user_id > ?" , "12").each do |topic|
	if !score.has_key?(topic.entity_id) 
	  score[topic.entity_id]||={}
	  puts "Creating hash for "+topic.entity_id.to_s
	else
	  puts "adding to hash for "+topic.entity_id.to_s
	end
	if !score[topic.entity_id].has_key?("score") # will now return true or false
    	score[topic.entity_id]["score"] = topic.high_score
    	score[topic.entity_id]["count"] = 1
  	else
    	score[topic.entity_id]["score"] += topic.high_score
    	score[topic.entity_id]["count"] += 1
  	end
end
score.each do |key, value|
	score[key]["average"]|| 
	score[key]["average"] = value["score"].to_f/value["count"].to_f
end

score.sort_by { |k, v| v["average"] }
score.each do |key, value|
	topic = SecondTopic.where(:id => key).first
	puts topic.name
end
##############

score ={}
scoreCount = {}
UserEntityScore.where(:entity_type => "SecondTopic").where("user_id > ?" , "12").includes(:user).each do |topic|
	if !score.has_key?(topic.entity_id) 
	  score[topic.entity_id]||={}
	  puts "Creating hash for "+topic.entity_id.to_s
	else
	  puts "adding to hash for "+topic.entity_id.to_s
	end
	if topic.high_score ==0
	  if !score[topic.entity_id].has_key?("count") # will now return true or false
	    score[topic.entity_id]["count"] = 1
	  else
	    score[topic.entity_id]["count"] += 1
	    if(topic.entity_id == 237)
	      puts topic.entity_id.to_s + score[topic.entity_id]["count"].to_s + " User name is "+ topic.user.id
	    end
	  end
	end
end
score = score.sort_by { |k, v| v["count"] }.reverse!
score.each do |key, value|
  topic = SecondTopic.where(:id => key).includes(:chapter,:standard).first
  if(topic.standard.standard_number == 6)
	  puts topic.chapter.name + ":" + topic.name + ":" + value["count"].to_s
	end
end
score.each do |key, value|
  topic = SecondTopic.where(:id => key).includes(:chapter,:standard).first
  if(topic.standard.standard_number == 7)
	  puts topic.chapter.name + ":" + topic.name + ":" + value["count"].to_s
	end
end
##############
questions = {}
DiagnosticTestAttemptScq.where(:attempt => 2).where("diagnostic_test_attempt_id > ?" , "35").includes(:short_choice_question).each do |q|
  topic = SecondTopic.where(:id => q.short_choice_question.second_topic_id).includes(:chapter,:standard).first
  if !questions.has_key?(topic.id) # will now return true or false
	questions[topic.id] = 1
  else
	questions[topic.id] += 1
  end
end
questions = questions.sort_by { |k, v| v }.reverse!
questions.each do |key, value|
  second_topic = SecondTopic.where(:id => key).includes(:chapter,:standard).first

  if(second_topic.standard.standard_number == 6)
	  puts second_topic.chapter.name + ":" + second_topic.name + ":" + value.to_s
	end
end

questions.each do |key, value|
  second_topic = SecondTopic.where(:id => key).includes(:chapter,:standard).first

  if(second_topic.standard.standard_number == 7)
	  puts second_topic.chapter.name + ":" + second_topic.name + ":" + value.to_s
	end
end

