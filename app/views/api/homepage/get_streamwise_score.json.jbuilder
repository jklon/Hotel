json.streams do
  json.array! @stream do |stream|
    json.id stream.id
    json.name stream.name
    json.scorecard do
      json.array! stream.user_entity_scores do |score|
      	if score.user == @user
          json.score score.high_score
          json.diamonds score.diamonds
          json.proficiency score.proficiency
        end
      end
    end
    json.topics do
      json.array! stream.second_topics do |topic|
        json.id topic.id
        json.name topic.name
        json.scorecard do
          json.array! topic.user_entity_scores do |topic_score|
      	    if topic_score.user == @user
              json.score topic_score.high_score
              json.diamonds topic_score.diamonds
              json.proficiency topic_score.proficiency
            end
          end
        end
      end
    end
  end
end