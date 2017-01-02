class DiagnosticTestAttempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :diagnostic_test

  def evaluate_test(question_answers,user)
    stream_hash = {}
    ShortChoiceQuestion.where(:id => question_answers.keys).includes(:stream, :second_topic).each do |q|
      stream_hash[q.stream_id] ||= {'other_details' => {'stream_name' => q.stream.name}, 'second_topics' => {}}
      stream_hash[q.stream_id]['second_topics'][q.second_topic_id] ||= {}
      stream_hash[q.stream_id]['second_topics'][q.second_topic_id] = {'score' => question_answers[q.id.to_s]['score'],
      'second_topic_name' => q.second_topic.name}
      if !stream_hash[q.stream_id]['other_details'].has_key?("question_count") # will now return true or false
        stream_hash[q.stream_id]['other_details']["question_count"] = 1
        stream_hash[q.stream_id]['other_details']["total_score"] = question_answers[q.id.to_s]['score'].to_i
      else
        stream_hash[q.stream_id]['other_details']["question_count"] += 1
        stream_hash[q.stream_id]['other_details']["total_score"] += question_answers[q.id.to_s]['score'].to_i
      end
      
      if question_answers[q.id.to_s]['score'] == "0"
        new_lowest_position = q.second_topic.stream_position
        existing_lowest_position = stream_hash[q.stream_id]['other_details']['lowest_position']
        if ( not existing_lowest_position ) or ( new_lowest_position < existing_lowest_position.to_i )
          stream_hash[q.stream_id]['other_details']['lowest_second_topic_id'] = q.second_topic_id
          stream_hash[q.stream_id]['other_details']['lowest_position'] = new_lowest_position

          puts user.email
          userCurrentStanding = UserCurrentStanding.where(:user => user, :entity_type => 'SecondTopic', :stream_id =>q.stream_id).first
          if (userCurrentStanding)
            userCurrentStanding.update_columns(:entity_id =>q.second_topic_id)
            userCurrentStanding.save!
          else
            UserCurrentStanding.create!(:user => user, :entity_type => 'SecondTopic', :stream_id =>q.stream_id,:entity_id =>q.second_topic_id)
          end


        end
      end
      stream_hash[q.stream_id]['other_details']["average_score"] = (stream_hash[q.stream_id]['other_details']["total_score"].to_f)/(stream_hash[q.stream_id]['other_details']["question_count"])
    end

    return stream_hash
  end
end
