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

    question_analysis = {}
    difficulty_breakup ={}
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
      puts question_answers[q.id.to_s]['attempt'].to_i
      difficulty_breakup["total"]||={}
      difficulty_breakup["total"]["total"]||=0
      difficulty_breakup["total"]["correct"]||=0
      difficulty_breakup["total"]["incorrect"]||=0
      difficulty_breakup["total"]["unattempted"]||=0
      difficulty_breakup["total"]["total"]+=1
      difficulty_breakup["total"]["correct"]+=1 if question_answers[q.id.to_s]['attempt'].to_i ==3
      difficulty_breakup["total"]["incorrect"]+=1 if question_answers[q.id.to_s]['attempt'].to_i ==2
      difficulty_breakup["total"]["unattempted"]+=1 if question_answers[q.id.to_s]['attempt'].to_i <2
      if q.difficulty

        difficulty_breakup[q.difficulty]||={}
        if !difficulty_breakup[q.difficulty].has_key?("total")
          difficulty_breakup[q.difficulty]["total"]=1
          difficulty_breakup[q.difficulty]["correct"]=0
          difficulty_breakup[q.difficulty]["incorrect"]=0
          difficulty_breakup[q.difficulty]["unattempted"]=0
        else
          difficulty_breakup[q.difficulty]["total"]+=1
        end
        puts question_answers[q.id.to_s]['attempt']
        difficulty_breakup[q.difficulty]["correct"]+=1 if question_answers[q.id.to_s]['attempt'].to_i ==3
        difficulty_breakup[q.difficulty]["incorrect"]+=1 if question_answers[q.id.to_s]['attempt'].to_i ==2
        difficulty_breakup[q.difficulty]["unattempted"]+=1 if question_answers[q.id.to_s]['attempt'].to_i < 2
        
      end

      question_analysis[q.id]||={}
      question_analysis[q.id]["index"]=question_answers[q.id.to_s]['index'].to_i+1
      question_analysis[q.id]["chapter"]=q.chapter.name
      question_analysis[q.id]["second_topic"]=q.second_topic.name
      question_analysis[q.id]["attempt"]=question_answers[q.id.to_s]['attempt'].to_i
      question_analysis[q.id]["difficulty"]=q.difficulty if q.difficulty

      puts "topic Score"+second_topic_score.to_s
      puts question_answers[q.id.to_s]['score'].to_i
      if !second_topic_score.has_key?(q.second_topic_id)
        second_topic_score[q.second_topic_id] ={}
        second_topic_score[q.second_topic_id]["name"] = q.second_topic.name
        second_topic_score[q.second_topic_id]["total_time_spent"]= question_answers[q.id.to_s]['time_taken'].to_f
        second_topic_score[q.second_topic_id]["question_count"] = 1
        second_topic_score[q.second_topic_id]["correct_count"] = 0
        second_topic_score[q.second_topic_id]["total_score"] = question_answers[q.id.to_s]['score'].to_i
      else
        second_topic_score[q.second_topic_id]["total_score"] += question_answers[q.id.to_s]['score'].to_i
        second_topic_score[q.second_topic_id]["total_time_spent"]+= question_answers[q.id.to_s]['time_taken'].to_f
        second_topic_score[q.second_topic_id]["question_count"] += 1
      end
      second_topic_score[q.second_topic_id]["correct_count"] +=1 if question_answers[q.id.to_s]['attempt'].to_i ==3

      puts "chapter Score"+chapter_score.to_s
      puts question_answers[q.id.to_s]['score'].to_i
      if !chapter_score.has_key?(q.chapter_id)
        chapter_score[q.chapter_id] ={}
        chapter_score[q.chapter_id]["name"] = q.chapter.name
        chapter_score[q.chapter_id]["total_time_spent"]= question_answers[q.id.to_s]['time_taken'].to_f
        chapter_score[q.chapter_id]["question_count"] = 1
        chapter_score[q.chapter_id]["correct_count"] =0
        chapter_score[q.chapter_id]["total_score"] = question_answers[q.id.to_s]['score'].to_i
      else
        chapter_score[q.chapter_id]["total_score"] += question_answers[q.id.to_s]['score'].to_i
        chapter_score[q.chapter_id]["total_time_spent"]+= question_answers[q.id.to_s]['time_taken'].to_f
        chapter_score[q.chapter_id]["question_count"] += 1
      end
      chapter_score[q.chapter_id]["correct_count"] +=1 if question_answers[q.id.to_s]['attempt'].to_i ==3
      
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
      value["other_details"]["average_score"] = average_score
      UserEntityScore.create!(:user => user, :entity_type => 'Stream', :high_score =>average_score.to_i,:entity_id =>key,
        :test_type => 'Diagnostic', :test_id => attempt.id)
    end
    second_topic_score.each do |second_topic,value|
      average_score = value["total_score"].to_f/value["question_count"]
      value["average_score"] = average_score
      value["average_time_spent"] = value["total_time_spent"].to_f/value["question_count"]
      UserEntityScore.create!(:user => user, :entity_type => 'SecondTopic', :high_score =>average_score.to_i,:entity_id =>second_topic,
        :test_type => 'Diagnostic', :test_id => attempt.id)
    end
    chapter_score.each do |chapter,value|
      average_score = value["total_score"].to_f/value["question_count"]
      value["average_score"] = average_score
      value["average_time_spent"] = value["total_time_spent"].to_f/value["question_count"]
      UserEntityScore.create!(:user => user, :entity_type => 'Chapter', :high_score =>average_score.to_i,:entity_id =>chapter,
        :test_type => 'Diagnostic', :test_id => attempt.id)
    end

    personalized_test_remaining = DiagnosticTestPersonalization.where(:user=> user,:attempted => false).count
    personalized_test_remaining = attempt.generate_personalized_test( user,attempt,true)["personalized"] if attempt.diagnostic_test.test_type == "Chapterwise"
    response_hash ={}

    response_hash["result"]||={}
    response_hash["result"]["streams"]||={}
    response_hash["result"]["streams"]=stream_hash
    response_hash["result"]["chapters"]||={}
    response_hash["result"]["chapters"]=chapter_score
    response_hash["result"]["second_topics"]||={}
    response_hash["result"]["second_topics"]=second_topic_score
    response_hash["difficulty_breakup"]||={}
    response_hash["difficulty_breakup"]=difficulty_breakup
    response_hash["question_analysis"]||={}
    response_hash["question_analysis"]=question_analysis
    response_hash["weak_entity"]||={}
    response_hash["weak_entity"] = get_weak_entity(attempt)
    response_hash["personalized_test_remaining"] = personalized_test_remaining
    return response_hash
  end
  


  def get_weak_entity(attempt)
    incorrectCounter = {}
    max_incorrect =0
    DiagnosticTestAttemptScq.where(:diagnostic_test_attempt => attempt).each do |scq|
      entity_id = scq.short_choice_question.chapter_id if attempt.diagnostic_test.test_type == "Chapterwise"
      entity_name = scq.short_choice_question.chapter.name if attempt.diagnostic_test.test_type == "Chapterwise"
      entity_id = scq.short_choice_question.second_topic_id if attempt.diagnostic_test.test_type == "Topicwise"
      entity_name = scq.short_choice_question.second_topic.name if attempt.diagnostic_test.test_type == "Topicwise"
      incorrectCounter[entity_id]||={}
      if !incorrectCounter[entity_id].has_key?("total")
        incorrectCounter[entity_id]["total"] = 1
        incorrectCounter[entity_id]["name"] = entity_name
        incorrectCounter[entity_id]["incorrect"] = 1 if scq.attempt == 2 || scq.attempt == 1
        incorrectCounter[entity_id]["incorrect"] = 0 if scq.attempt != 2
      else
        incorrectCounter[entity_id]["total"] += 1
        if scq.attempt == 2 || scq.attempt == 1
          incorrectCounter[entity_id]["incorrect"] += 1 
          max_incorrect = [incorrectCounter[entity_id]["incorrect"], max_incorrect].max
        end
      end
    end
      
    response_hash ={}
    response_hash["entity_type"]=attempt.diagnostic_test.test_type
    response_hash["max_incorrect"]=max_incorrect
    response_hash["entity_list"]||={}
    response_hash["entity_list"]=incorrectCounter
    return response_hash
  end



  def generate_personalized_test(user,attempt,generate)
    personalized = 0
    incorrectCounter ={}
    max_incorrect =0
    personalized_test_count = DiagnosticTestPersonalization.where(:user=> user,:attempted => false).count
    if personalized_test_count > 0
      puts "test already generated"
      incorrectCounter["personalized"]=personalized_test_count
      return incorrectCounter
    end
    if attempt.diagnostic_test.test_type == "Chapterwise" 
      incorrectCounter = get_weak_entity(attempt)
      max_incorrect = incorrectCounter["max_incorrect"]
      incorrectCounter = incorrectCounter["entity_list"]
      puts incorrectCounter
      if (max_incorrect > 1) && generate
        incorrectCounter.each do |key, value|
          if key.is_a? Integer
            if ( value["incorrect"].to_f / value["total"].to_f ) > 0.5
              personalized += 1
              personalized_test = DiagnosticTestPersonalization.create(:user=> user,:attempted => false)
              test = DiagnosticTest.create(:standard_id => attempt.diagnostic_test.standard_id, 
                :subject_id => attempt.diagnostic_test.standard_id, :name=> "Random_Question", :test_type => "Topicwise", 
                :diagnostic_test_personalization => personalized_test, :personalization_type => 1,:entity_type =>"Chapter",
                :entity_id => key )
              
              SecondTopic.where(:chapter_id => key).each do |topic|
                question_ids = ShortChoiceQuestion.where(:second_topic_id => topic.id).pluck(:id)
                question_count = [3, question_ids.count].min
                
                while question_count > 0 
                  question_id = question_ids[rand(question_ids.count)]
                  DiagnosticTestQuestion.create(:question_type => "ShortChoiceQuestion", :question_id => question_id,
                   :diagnostic_test_id => test.id)
                  question_ids.delete(question_id)
                  question_count = question_count -1
                end

              end
            end
          end
        end
        
      end
    end
    incorrectCounter["personalized"]=personalized
    return incorrectCounter
  end


  private


end

