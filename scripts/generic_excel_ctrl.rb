# Parse Excel to import worksheet questions

require 'rubyXL'

book = RubyXL::Parser.parse('scripts/game_examples.xlsx')
book.each do |scq_sheet|

  scq_sheet.each_with_index do |row, index|
    next if index ==0
    break if index ==10
    break if !row.cells[0]
    standard    = Standard.find_by(:standard_number => row.cells[0].value[2])
    puts "Standard: "+standard.name
    subject     = Subject.find_by(:standard => standard, :name => row.cells[1].value)
    puts "subject: "+subject.name
    stream      = Stream.find_by(:name => row.cells[3].value)
    puts "stream: "+stream.name
    # chapter     = Chapter.find_by(:name => row.cells[6].value)
    # puts "chapter: "+chapter.name
    second_topic= SecondTopic.find_by(:name => row.cells[9].value)
    puts "second_topic: "+second_topic.name
    
    sub_topic = SubTopic.find_by(:name => row.cells[11].value)
    if !sub_topic
      sub_topic = SubTopic.create(:name=> row.cells[11].value, :subject => subject, :standard => standard,:stream => stream, :second_topic => second_topic)
    end
    if sub_topic
      puts "sub_topic: "+sub_topic.name 
    end
    
    question_style = QuestionStyle.find_by(:name => row.cells[13].value)
    if !question_style
      question_style = QuestionStyle.create(:name=> row.cells[13].value, :alias => row.cells[14].value)
    end
    if question_style
      puts "question_style: "+row.cells[13].value
    end
    
    worksheet = Worksheet.find_by(:question_style => question_style, :sub_topic => sub_topic)
    if !worksheet
      worksheet = Worksheet.create(:question_style=> question_style, :sub_topic => sub_topic)
    end
    
    question_text = ""
    question_text = row.cells[15].value.to_s if row.cells[15]
    hint_text = ""
    hint_text = row.cells[16].value if row.cells[16]
    puts "question.text: "+question_text.to_s
    question = ShortChoiceQuestion.create(:question_text => question_text,
      :standard => standard, :subject => subject, :stream => stream, :second_topic => second_topic,
      :sub_topic => sub_topic, :question_style => question_style, :worksheet_sequence_no => row.cells[14].value.to_i)
    WorksheetQuestion.create(:question_type => "ShortChoiceQuestion", :question_id => question.id,
     :worksheet => worksheet)

    count = 17
    count = 18 if row.cells[13].value == "TrueFalse" || row.cells[13].value == "ShortChoice"
    while !row.cells[count].nil?
      break if row.cells[count].value.to_s.length ==0
      puts "count: "+count.to_s
      puts case row.cells[13].value
      when "Combination"
        puts "Combination: answer text is " +row.cells[count].value.to_s
        puts "Combination: correct answer multiple is " +row.cells[count+1].value.to_s
        ShortChoiceAnswer.create(:short_choice_question => question,
         :answer_text => row.cells[count].value.to_s,:correct_multiple =>row.cells[count+1].value.to_i)
        count = count+2
      when "Comparision"
        puts "Comparision: answer text is " +row.cells[count].value.to_s
        puts "Comparision: correct order is " +row.cells[count+1].value.to_s
        ShortChoiceAnswer.create(:short_choice_question => question,
         :answer_text => row.cells[count].value.to_s,:correct_order =>row.cells[count+1].value.to_i)
        count = count+2
      when "Equivalence"
        puts "Equivalence: answer text is " +row.cells[count].value.to_s
        puts "Equivalence: correct bool is " +row.cells[count+1].value.to_s
        answer = ShortChoiceAnswer.create(:short_choice_question => question,
         :answer_text => row.cells[count].value.to_s,:correct => false)
        answer.correct = true if row.cells[count+1].value.to_i==1
        answer.save!
        count = count+2
      when "Estimation"
        puts "Estimation: answer text is " +row.cells[count].value.to_s
        answer = ShortChoiceAnswer.create(:short_choice_question => question,
         :answer_text => row.cells[count].value.to_s)
        count = count+1
      when "FillBlank"
        puts "Fill Blank: answer text is " +row.cells[count].value.to_s
        answer = ShortChoiceAnswer.create(:short_choice_question => question,
         :answer_text => row.cells[count].value.to_s)
        count = count+1
      when "TrueFalse"
        puts "TrueFalse: correct answer text is " +row.cells[17].value.to_s
        answer = ShortChoiceAnswer.create(:short_choice_question => question,
         :answer_text => row.cells[count].value.to_s,:correct => false)
        answer.correct = true if row.cells[17].value.to_i == (count-17)
        answer.save!
        count = count+1
      when "ShortChoice"
        puts "ShortChoice: correct answer text is " +row.cells[17].value.to_s
        answer = ShortChoiceAnswer.create(:short_choice_question => question,
         :answer_text => row.cells[count].value.to_s,:correct => false)
        answer.correct = true if row.cells[17].value.to_i == (count-17)
        answer.save!
        count = count+1
      else
        count = count+1
      end
      # ShortChoiceAnswer.create(:short_choice_question => question,
      #    :answer_text => row.cells[count+1])
      # count = count+2
    end
  end
end


#####################

# Generating excel sheet based on short choice question filters
require 'rubyXL'

book = RubyXL::Parser.parse('scripts/generate_short_choice_question.xlsx')
master_sheet = book[0]
row = 1

ShortChoiceQuestion.where(:question_style_old => "single correct").where(:second_topic_id => 80).each do |q|
  master_sheet.add_cell( row,0, q.standard.name)
  puts "Standard: "+q.standard.name
  master_sheet.add_cell( row,1, q.subject.name)
  puts "subject: "+q.subject.name
  master_sheet.add_cell( row,3, q.stream.name)
  puts "stream: "+q.stream.name
  master_sheet.add_cell( row,9, q.second_topic.name)
  puts "second_topic: "+q.second_topic.name
  master_sheet.add_cell( row,13, q.question_style_old)
  puts "question_style: "+q.question_style_old.to_s
  master_sheet.add_cell( row,15, q.question_text)
  puts "question_text: "+q.question_text
  if q.hint_text
    master_sheet.add_cell( row,16, q.hint_text)
    puts "question_text: "+q.hint_text 
  end
  count = 17
  count = 18 if q.question_style_old == "TrueFalse" || q.question_style_old == "single correct"
  ShortChoiceAnswer.where(:short_choice_question => q).each do |ans|
    puts case q.question_style_old
    when "TrueFalse"
      master_sheet.add_cell( row,17, count-17) if ans.correct
      master_sheet.add_cell( row,count, ans.answer_text)
      count = count+1
    when "ShortChoice"
      master_sheet.add_cell( row,17, count-17) if ans.correct
      master_sheet.add_cell( row,count, ans.answer_text)
      count = count+1
    when "single correct"
      master_sheet.add_cell( row,17, count-17) if ans.correct
      master_sheet.add_cell( row,count, ans.answer_text)
      count = count+1
    when "blank"
      master_sheet.add_cell( row,17, ans.answer_text)
      count = count+1
    when 
      count = count+1
    end
  end
  row = row+1

end
book.save


##########################

# Getting scq based on question_text

ShortChoiceQuestion.where("question_text LIKE ?" , "%Upon arranging the following integers%").each do |q|
  puts q.question_text
  puts q.id
end
###########################

require 'rubyXL'

# Generating Report for each student attempt of diagnostic tests
require 'rubyXL'

book = RubyXL::Parser.parse('scripts/Prashant_Report.xlsx')
master_sheet = book[1]
row = master_sheet[0]
row_count =0
master_sheet.add_cell( row_count,0, "Username")
master_sheet.add_cell( row_count,1, "Score") 
master_sheet.add_cell( row_count,2, "Type of mistake")
master_sheet.add_cell( row_count,3, "Chapter Name")
master_sheet.add_cell( row_count,4, "Question Text") 
master_sheet.add_cell( row_count,5, "Answer selected") 
master_sheet.add_cell( row_count,6, "Total time spent on question")
master_sheet.add_cell( row_count,7, "Result Flag")
row_count = row_count +1;

User.where("id >?","12").each do |user|
  puts "User name: "+user.first_name
  master_sheet.add_cell( row_count,0, user.first_name)
  DiagnosticTestAttempt.where(:user_id => user.id).each do |attempt|
    score = UserEntityScore.where(:test_id => attempt.id).where(:user_id => user.id).where(:entity_type => "Stream").first

    puts "Total streamscore: "+score.high_score.to_s if score
    master_sheet.add_cell( row_count,1, score.high_score ) if score
    
    DiagnosticTestAttemptScq.where(:diagnostic_test_attempt => attempt).includes(:short_choice_question, :short_choice_answer)
    .where(:attempt => [1,2]).each do |scq|
      puts "Incorrectly replied "
      puts "Chapter Name "+Chapter.where(:id => scq.short_choice_question.chapter_id).first.name
      puts "Question Text "+scq.short_choice_question.question_text
      answer = ShortChoiceAnswer.where(:id => scq.short_choice_answer_id).first
      puts "Answer selected "+answer.answer_text if answer
      puts "Time Taken "+scq.time_spent.to_s
      puts "Attempt Flag "+scq.attempt.to_s
      master_sheet.add_cell( row_count,2, "Incorrectly replied ")
      master_sheet.add_cell( row_count,3, Chapter.where(:id => scq.short_choice_question.chapter_id).first.name)
      master_sheet.add_cell( row_count,4, scq.short_choice_question.question_text) 
      master_sheet.add_cell( row_count,5, answer.answer_text) if answer
      master_sheet.add_cell( row_count,6, scq.time_spent.to_s)
      master_sheet.add_cell( row_count,7, scq.attempt.to_s)
      row_count = row_count +1;
    end
    DiagnosticTestAttemptScq.where(:diagnostic_test_attempt => attempt).includes(:short_choice_question, :short_choice_answer)
    .where(:attempt => 3).where("score < ?", "1000").each do |scq|
      puts "Correctly but Slowly replied"
      puts "Question Text "+scq.short_choice_question.question_text
      master_sheet.add_cell( row_count,3, scq.short_choice_question.question_text) 
      answer = ShortChoiceAnswer.where(:id => scq.short_choice_answer_id).first
      puts "Answer selected "+answer.answer_text if answer
      puts "Attempt Flag "+scq.attempt.to_s
      puts "Time Taken "+scq.time_spent.to_s
      puts "Chapter Name "+Chapter.where(:id => scq.short_choice_question.chapter_id).first.name
      master_sheet.add_cell( row_count,2, "Correctly but Slowly replied")
      master_sheet.add_cell( row_count,3, Chapter.where(:id => scq.short_choice_question.chapter_id).first.name)
      master_sheet.add_cell( row_count,4, scq.short_choice_question.question_text) 
      master_sheet.add_cell( row_count,5, answer.answer_text) if answer
      master_sheet.add_cell( row_count,6, scq.time_spent.to_s)
      master_sheet.add_cell( row_count,7, scq.attempt.to_s)
      row_count = row_count +1;
    end

  end
  row_count = row_count +1;
end

book.save



####################
# How to generate macro report

questionHash ={}
DiagnosticTestAttemptScq.includes(:diagnostic_test_attempt,:short_choice_question).each do |scq|
  if(scq.diagnostic_test_attempt.user_id > 12)
    questionHash[scq.short_choice_question_id]||={}
    if !questionHash[scq.short_choice_question_id].has_key?("total_time")
      questionHash[scq.short_choice_question_id]["question_text"] = scq.short_choice_question.question_text
      questionHash[scq.short_choice_question_id]["topic_id"] = scq.short_choice_question.second_topic_id
      topic = SecondTopic.where(:id => scq.short_choice_question.second_topic_id).first
      questionHash[scq.short_choice_question_id]["topic_name"] = topic.name if topic
      questionHash[scq.short_choice_question_id]["total_time"] = scq.time_spent
      questionHash[scq.short_choice_question_id]["total_correct"] = 0
      questionHash[scq.short_choice_question_id]["total_incorrect"] = 0
      questionHash[scq.short_choice_question_id]["total_skipped"] = 0
      questionHash[scq.short_choice_question_id]["total_correct"] = 1 if scq.attempt ==3
      questionHash[scq.short_choice_question_id]["total_incorrect"] = 1 if scq.attempt ==2
      questionHash[scq.short_choice_question_id]["total_skipped"] = 1 if scq.attempt ==1
      questionHash[scq.short_choice_question_id]["count"] = 1
    else
      questionHash[scq.short_choice_question_id]["total_time"] += scq.time_spent
      questionHash[scq.short_choice_question_id]["count"] += 1
      questionHash[scq.short_choice_question_id]["total_correct"] += 1 if scq.attempt ==3
      questionHash[scq.short_choice_question_id]["total_incorrect"] += 1 if scq.attempt ==2
      questionHash[scq.short_choice_question_id]["total_skipped"] += 1 if scq.attempt ==1
    end
  end
end
questionHash.each do |question,value|
  average_time = value["total_time"].to_f/value["count"]
  questionHash[question]["average_time"] = average_time
end
questionHash = questionHash.sort_by { |k, v| v["topic_id"] }

require 'rubyXL'

book = RubyXL::Parser.parse('scripts/Prashant_Report.xlsx')
master_sheet = book[2]
row = master_sheet[0]
row_count =0
master_sheet.add_cell( row_count,0, "Question Id")
master_sheet.add_cell( row_count,1, "Question Text") 
master_sheet.add_cell( row_count,2, "Topic Name")
master_sheet.add_cell( row_count,3, "Average Time")
master_sheet.add_cell( row_count,4, "Total Correct") 
master_sheet.add_cell( row_count,5, "total Incorrect") 
master_sheet.add_cell( row_count,6, "Total Skipped")
row_count = row_count +1;

questionHash.each do |question,value|
  master_sheet.add_cell( row_count,0, question)
  master_sheet.add_cell( row_count,1, value["question_text"]) 
  master_sheet.add_cell( row_count,2, value["topic_name"])
  master_sheet.add_cell( row_count,3, value["average_time"])
  master_sheet.add_cell( row_count,4, value["total_correct"]) 
  master_sheet.add_cell( row_count,5, value["total_incorrect"]) 
  master_sheet.add_cell( row_count,6, value["total_skipped"])
  row_count = row_count +1;
end
book.save

#####################
require 'rubyXL'

#Exporting scq from db to excel and keeping equal weightage to easy, medium and hard.
book = RubyXL::Parser.parse('scripts/Prashant_Report.xlsx')
master_sheet = book[3]
row = master_sheet[0]
row_count =0
master_sheet.add_cell( row_count,0, "Standard Number")
master_sheet.add_cell( row_count,1, "Stream Name") 
master_sheet.add_cell( row_count,2, "Chapter Name")
master_sheet.add_cell( row_count,3, "Topic Name")
master_sheet.add_cell( row_count,4, "Question Text") 
master_sheet.add_cell( row_count,5, "Difficulty") 
row_count = row_count +1


numberList = [6,7]
numberList.each do |number|
  Standard.where(:standard_number => number).each do |standard|
    Stream.all.each do |stream|
      Chapter.where(:standard_id => standard.id).where(:stream_id => stream.id).each do |chapter|
        SecondTopic.where(:chapter_id => chapter.id).each do |topic|
          ids = ShortChoiceQuestion.where(:second_topic_id => topic.id).pluck(:id)
          count = [6, ids.count].min
          row_count = populate(ids,count,standard,stream,chapter,topic,master_sheet,row_count)
        end
      end
    end
  end
end

numberList = [8,9,10]
numberList.each do |number|
  Standard.where(:standard_number => number).each do |standard|
    Stream.all.each do |stream|
      Chapter.where(:standard_id => standard.id).where(:stream_id => stream.id).each do |chapter|
        SecondTopic.where(:chapter_id => chapter.id).each do |topic|
          
          
          hard_ids = ShortChoiceQuestion.where(:second_topic_id => topic.id,:difficulty =>"hard").pluck(:id)
          hard_count = [2, hard_ids.count].min
          puts "Hard "+hard_count.to_s+topic.name
          

          medium_ids = ShortChoiceQuestion.where(:second_topic_id => topic.id,:difficulty =>"medium").pluck(:id)
          medium_count = [(4-hard_count), medium_ids.count].min
          puts "Medium "+medium_count.to_s
          

          easy_ids = ShortChoiceQuestion.where(:second_topic_id => topic.id,:difficulty =>"easy").pluck(:id)
          easy_count = [(6-hard_count-medium_count), easy_ids.count].min
          puts "Easy "+easy_count.to_s
          
          
          if easy_ids.count < 6-hard_count-medium_count
            medium_add = [(6-hard_count-medium_count-easy_count),(medium_ids.count- medium_count)].min
            medium_count = medium_count + medium_add
          end

          row_count = populate(hard_ids,hard_count,standard,stream,chapter,topic,master_sheet,row_count)
          row_count = populate(medium_ids,medium_count,standard,stream,chapter,topic,master_sheet,row_count)
          row_count = populate(easy_ids,easy_count,standard,stream,chapter,topic,master_sheet,row_count)

          total_count = easy_count+medium_count+hard_count
          if total_count<6
            puts "Smaller topic"
            ids = ShortChoiceQuestion.where(:second_topic_id => topic.id).pluck(:id)
            count = [6 - total_count, ids.count].min
            row_count = populate(ids,count,standard,stream,chapter,topic,master_sheet,row_count)
          end
        end
      end
    end
  end
end


def populate(ids,count,standard,stream,chapter,topic,master_sheet,row_count)
  # puts ids
  puts "inside populate function"+count.to_s if count
  puts count
  while count > 0 
    ques_id = ids[rand(ids.count)]
    puts ques_id
    question =  ShortChoiceQuestion.where(:id => ques_id).first
    if question
      # puts question.question_text
      # puts topic.name
      # puts stream.name
      # puts chapter.name
      # puts standard.name
      
      master_sheet.add_cell( row_count,0, standard.name)
      master_sheet.add_cell( row_count,1, stream.name) 
      master_sheet.add_cell( row_count,2, chapter.name)
      master_sheet.add_cell( row_count,3, topic.name)
      master_sheet.add_cell( row_count,4, question.question_text) 

      if question.difficulty
        # puts question.difficulty
        master_sheet.add_cell( row_count,5, question.difficulty) 
      end
      ids.delete(ques_id)
      row_count = row_count+1
    else
      puts "no questions found"
      puts ids
      puts "selected question"+ques_id
    end
    count = count -1
  end
  return row_count
end
        
######################
#Exporting all scq for science chapters
require 'rubyXL'

book = RubyXL::Parser.parse('scripts/Class-9-Science.xlsx')



numberList = [9]
numberList.each do |number|
  master_sheet = book[0]
  row_count =0
  master_sheet.add_cell( row_count,0, "Standard Number")
  master_sheet.add_cell( row_count,1, "Stream Name") 
  master_sheet.add_cell( row_count,2, "Chapter Name")
  master_sheet.add_cell( row_count,3, "Topic Name")
  master_sheet.add_cell( row_count,4, "Question Id") 
  master_sheet.add_cell( row_count,5, "Question Text") 
  master_sheet.add_cell( row_count,6, "Difficulty Flag") 
  master_sheet.add_cell( row_count,7, "Difficulty Level") 
  master_sheet.add_cell( row_count,8, "Answer Option") 
  master_sheet.add_cell( row_count,9, "Answer Option") 
  master_sheet.add_cell( row_count,10, "Answer Option") 
  master_sheet.add_cell( row_count,11, "Answer Option") 
  master_sheet.add_cell( row_count,12, "Answer Option") 
  master_sheet.add_cell( row_count,12, "Correct Index") 
  row_count = row_count +1
  Standard.where(:standard_number => number).each do |standard|
    Stream.all.each do |stream|
      if stream.id>7
        Chapter.where(:standard_id => standard.id).where(:stream_id => stream.id).each do |chapter|
          SecondTopic.where(:chapter_id => chapter.id).each do |topic|
            ShortChoiceQuestion.where(:second_topic => topic).each do |question|
              subject = Subject.where(:id => topic.subject_id).first
              master_sheet.add_cell( row_count,0, subject.name)
              master_sheet.add_cell( row_count,1, stream.name) 
              master_sheet.add_cell( row_count,2, chapter.name)
              master_sheet.add_cell( row_count,3, topic.name)
              master_sheet.add_cell( row_count,4, question.id) 
              master_sheet.add_cell( row_count,5, question.question_text) 
              if question.difficulty
                # puts question.difficulty
                master_sheet.add_cell( row_count,6, question.difficulty) 
              end
              if question.level
                # puts question.difficulty
                master_sheet.add_cell( row_count,7, question.level) 
              end
              i=1
              correct = 0
              ShortChoiceAnswer.where(:short_choice_question => question).each do |answer|
                master_sheet.add_cell( row_count,7+i, answer.answer_text) 
                correct = i if answer.correct
                i+=1
                break if i==6
              end
              master_sheet.add_cell( row_count,13, correct) if correct >0
              row_count += 1
            end
          end
        end
      end
    end
  end
end

################



def populate(ids,test_id)
  while count > 0 && ids.count >0

    ques_id = ids[0]
    if ques_id
      puts "Inside if ques_id"
      puts ques_id 
      puts "Inside if short_choice_answer"
      WorksheetQuestion.create(:question_type => "ShortChoiceQuestion", :question_id => ques_id,
     :worksheet_id => test_id) if ques_id
      count = count -1
      puts "after if short_choice_answer"
      ids.delete(ques_id)
    else
      puts "else of ques_id"
      puts ids
    end
    puts "after if ques_id"
  end
end
