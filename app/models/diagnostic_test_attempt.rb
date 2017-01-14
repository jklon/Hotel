class DiagnosticTestAttempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :diagnostic_test
  has_many :diagnostic_test_attempt_scqs
  has_many :short_choice_questions, :through => :diagnostic_test_attempt_scqs,
   :source => :question, :source_type => "ShortChoiceQuestion"

  filterrific(
    default_filter_params: { search_query: "date(created_at) = '#{Date.today.to_s(:db)}'" },
    available_filters: [
      :search_query,
    ]
  )

  scope :search_query, lambda { |query|
    where(query)
  }


  


  def evaluate_test(question_answers,user,attempt)
    stream_hash = {}
    second_topic_score = {}
    chapter_score = {}
    personalization = DiagnosticTestPersonalization.where(:id => attempt.diagnostic_test.diagnostic_test_personalization_id).first
    personalization.update_columns(:attempted => true) if personalization
    personalization.save if personalization

    ShortChoiceQuestion.where(:id => question_answers.keys).includes(:stream, :second_topic).each do |q|
      #Create Rows in DiagnosticTestAttemptScq
      #DiagnosticTestAttemptScq.create!(:diagnostic_test_attempt =>attempt,:short_choice_question => q, 
      # puts "Question Details"
      # puts q.id
      # puts question_answers[q.id.to_s]['time_taken'].to_f
      # puts question_answers[q.id.to_s]['attempt'].to_i
      attempt_scq = DiagnosticTestAttemptScq.create!(:diagnostic_test_attempt => attempt,:short_choice_question => q,
        :time_spent => question_answers[q.id.to_s]['time_taken'].to_f, :attempt => question_answers[q.id.to_s]['attempt'].to_i,
        :short_choice_answer_id => question_answers[q.id.to_s]['answer_selected'].to_i, 
        :score => question_answers[q.id.to_s]['score'].to_f)
      if (question_answers[q.id.to_s]['selected_answers'])
        question_answers[q.id.to_s]['selected_answers'].keys.each do |a_id|
          # puts "Answer Details"
          # puts a.id
          # puts question_answers[q.id.to_s]['selected_answers'][a.id.to_s]["time_taken"]
          DiagnosticTestAttemptScqSca.create!(:diagnostic_test_attempt_scq => attempt_scq,:short_choice_answer_id => a_id,
            :time_spent => question_answers[q.id.to_s]['selected_answers'][a_id.to_s]["time_taken"].to_f,
            :attempt_order => question_answers[q.id.to_s]['selected_answers'][a_id.to_s]["index"].to_i)
        end
      else 
        puts q.id
      end

      #Adding To userEntityScore
      # UserEntityScore.create!(:user => user, :entity_type => 'SecondTopic', :high_score =>question_answers[q.id.to_s]['score'].to_i,:entity_id =>q.second_topic_id,
      #     :test_type => 'Diagnostic', :test_id => attempt.id)

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

      puts second_topic_score
      puts question_answers[q.id.to_s]['score'].to_i
      if !second_topic_score.has_key?(q.second_topic_id)
        second_topic_score[q.second_topic_id] ={}
        second_topic_score[q.second_topic_id]["total_score"] = question_answers[q.id.to_s]['score'].to_i
        second_topic_score[q.second_topic_id]["question_count"] = 1
      else
        second_topic_score[q.second_topic_id]["total_score"] += question_answers[q.id.to_s]['score'].to_i
        second_topic_score[q.second_topic_id]["question_count"] += 1
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
      second_topic_score.each do |second_topic,value|
        average_score = value["total_score"].to_f/value["question_count"]
        puts average_score
        UserEntityScore.create!(:user => user, :entity_type => 'SecondTopic', :high_score =>average_score.to_i,:entity_id =>second_topic,
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
  






  def generate_personalized_test(user,attempt)
    personalized = 0
    incorrectCounter ={}
    max_incorrect =0
    personalized_test = DiagnosticTestPersonalization.where(:user=> user,:attempted => false).first
    if personalized_test
      puts "test already generated"
      return 1
    end
    if attempt.diagnostic_test.test_type == "Chapterwise" 
      DiagnosticTestAttemptScq.where(:diagnostic_test_attempt => attempt).each do |scq|
        puts scq.short_choice_question.chapter_id
        incorrectCounter[scq.short_choice_question.chapter_id]||={}
        if !incorrectCounter[scq.short_choice_question.chapter_id].has_key?("total")
          incorrectCounter[scq.short_choice_question.chapter_id]["total"] = 1
          incorrectCounter[scq.short_choice_question.chapter_id]["incorrect"] = 1 if scq.attempt == 2
          incorrectCounter[scq.short_choice_question.chapter_id]["incorrect"] = 0 if scq.attempt != 2
        else
          incorrectCounter[scq.short_choice_question.chapter_id]["total"] += 1
          if scq.attempt == 2
            incorrectCounter[scq.short_choice_question.chapter_id]["incorrect"] += 1 
            max_incorrect = [incorrectCounter[scq.short_choice_question.chapter_id]["incorrect"], max_incorrect].max
          end
        end
      end

      puts max_incorrect
      puts incorrectCounter
      if max_incorrect > 1
        personalized_test = DiagnosticTestPersonalization.create(:user=> user,:attempted => false)
        test = DiagnosticTest.create(:standard_id => attempt.diagnostic_test.standard_id, 
          :subject_id => attempt.diagnostic_test.standard_id, :name=> "Random_Question", :test_type => "Topicwise", 
          :diagnostic_test_personalization => personalized_test, :personalization_type => 1 )
        incorrectCounter.each do |key, value|
          if ( value["incorrect"].to_f / value["total"].to_f ) > 0.5
            puts key
            topic_ids = SecondTopic.where(:chapter_id => key).pluck(:id)
            topic_count = [3, topic_ids.count].min
            
            while topic_count > 0 
              topic_id = topic_ids[rand(topic_ids.count)]
              question_ids = ShortChoiceQuestion.where(:second_topic_id => topic_id).pluck(:id)
              question_count = [3, question_ids.count].min
              
              while question_count > 0 
                question_id = question_ids[rand(question_ids.count)]
                DiagnosticTestQuestion.create(:question_type => "ShortChoiceQuestion", :question_id => question_id,
                 :diagnostic_test_id => test.id)
                question_ids.delete(question_id)
                question_count = question_count -1
              end
              
              topic_ids.delete(topic_id)
              topic_count = topic_count -1
            end
          
          end
        end
        personalized = 1
      end
    end
    return personalized
  end


  private


end

