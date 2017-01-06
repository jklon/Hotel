class DiagnosticTestAttempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :diagnostic_test
  has_many :diagnostic_test_attempt_scqs
  has_many :short_choice_questions, :through => :diagnostic_test_attempt_scqs,
   :source => :question, :source_type => "ShortChoiceQuestion"
  def evaluate_test(question_answers,user,attempt)
    stream_hash = {}
    stream_score = {}
    chapter_score = {}
    ShortChoiceQuestion.where(:id => question_answers.keys).includes(:stream, :second_topic).each do |q|
      #Create Rows in DiagnosticTestAttemptScq
      #DiagnosticTestAttemptScq.create!(:diagnostic_test_attempt =>attempt,:short_choice_question => q, 
      # puts "Question Details"
      # puts q.id
      # puts question_answers[q.id.to_s]['time_taken'].to_f
      # puts question_answers[q.id.to_s]['attempt'].to_i
      attempt_scq = DiagnosticTestAttemptScq.create!(:diagnostic_test_attempt => attempt,:short_choice_question => q,
        :time_spent => question_answers[q.id.to_s]['time_taken'].to_f, :attempt => question_answers[q.id.to_s]['attempt'].to_i,
        :short_choice_answer_id => question_answers[q.id.to_s]['answer_selected'].to_i)
        if (question_answers[q.id.to_s]['selected_answers'])
          ShortChoiceAnswer.where(:id => question_answers[q.id.to_s]['selected_answers'].keys).each do |a|
            # puts "Answer Details"
            # puts a.id
            # puts question_answers[q.id.to_s]['selected_answers'][a.id.to_s]["time_taken"]
            DiagnosticTestAttemptScqSca.create!(:diagnostic_test_attempt_scq => attempt_scq,:short_choice_answer => a,
        :time_spent => question_answers[q.id.to_s]['selected_answers'][a.id.to_s]["time_taken"].to_f,
         :attempt_order => question_answers[q.id.to_s]['selected_answers'][a.id.to_s]["index"].to_i)
          end
        else 
          puts q.id
        end

      #Adding To userEntityScore
      UserEntityScore.create!(:user => user, :entity_type => 'SecondTopic', :high_score =>question_answers[q.id.to_s]['score'].to_i,:entity_id =>q.second_topic_id,
          :test_type => 'Diagnostic', :test_id => attempt.id)

      #Start generating Response JSON
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

      puts chapter_score
      puts question_answers[q.id.to_s]['score'].to_i
      if !chapter_score.has_key?(q.chapter_id)
        chapter_score[q.chapter_id] ={}
        chapter_score[q.chapter_id]["total_score"] = question_answers[q.id.to_s]['score'].to_i
        chapter_score[q.chapter_id]["question_count"] = 1
      else
        chapter_score[q.chapter_id]["total_score"] += question_answers[q.id.to_s]['score'].to_i
        chapter_score[q.chapter_id]["question_count"] += 1
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
      stream_hash.each do |key, value|
        average_score = value["other_details"]["total_score"].to_f/value["other_details"]["question_count"]
        puts average_score
        UserEntityScore.create!(:user => user, :entity_type => 'Stream', :high_score =>average_score.to_i,:entity_id =>key,
          :test_type => 'Diagnostic', :test_id => attempt.id)
      end
      chapter_score.each do |chapter,value|
        average_score = value["total_score"].to_f/value["question_count"]
        puts average_score
        UserEntityScore.create!(:user => user, :entity_type => 'Chapter', :high_score =>average_score.to_i,:entity_id =>chapter,
          :test_type => 'Diagnostic', :test_id => attempt.id)
      end
    return stream_hash
  end
end
