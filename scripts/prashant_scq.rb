require 'rubyXL'

book = RubyXL::Parser.parse('scripts/Prashant_Question.xlsx')
scq_sheet = book[0]

standard    = Standard.where(:standard_number => 7).first
subject     = Subject.where(:standard => standard, :name => "Maths").first
stream      =  Stream.first
empty_row   = false
question    = ShortChoiceQuestion.first
def question_object(given_text)
  text = given_text.to_s
  question = {}
  question["text"] = text
  question["image"] = ""
  if text.include? "<img src"
    image_url = text[(text.index('http'))..-1]
    image_url = image_url[0..(image_url.index('/>')-2)]
    final_text = text[0..(text.index('<img')-1)]
    question["image"] = image_url
    question["text"] = final_text
  end
  return question
end


diagnostic_test = DiagnosticTest.create(:standard_id => standard.id,:subject_id => standard.id, :name => "Prashant_Question")

scq_sheet.each_with_index do |row, index|
#row = scq_sheet[1]
  # row = scq_sheet[1]
  next if index ==0
  if (row.cells[2])
    chapter = Chapter.find_by(:name => row.cells[3].value)
    stream = Stream.find_by(:id => chapter.stream_id)
    second_topic_name = row.cells[2].value
    second_topic = SecondTopic.where(:name => second_topic_name, :standard => standard, :subject => subject, :stream => stream, :chapter => chapter).first
    #puts second_topic_name if not second_topic
    second_topic = SecondTopic.create(:name => second_topic_name, :standard => standard, :subject => subject, :stream => stream, :chapter => chapter) if not second_topic
    
    puts question_object(row.cells[1].value)["image"]
    puts question_object(row.cells[1].value)["text"] 


    question = ShortChoiceQuestion.create(:question_text => question_object(row.cells[1].value)["text"] ,
      :question_image => question_object(row.cells[1].value)["image"],:standard => standard, 
      :subject => subject, :stream => stream, :second_topic => second_topic, :chapter => chapter, :source_id => 3)
    for i in 0..3
      row_count = (2*i)+7
      puts row.cells[row_count].value
      if(row.cells[row_count-1].value == row.cells[14].value)
        ShortChoiceAnswer.create(:short_choice_question => question,:answer_text => question_object(row.cells[row_count].value)["text"],
        :image =>question_object(row.cells[row_count].value)["image"], :correct => true)
      else
        ShortChoiceAnswer.create(:short_choice_question => question,:answer_text => question_object(row.cells[row_count].value)["text"],
        :image =>question_object(row.cells[row_count].value)["image"], :correct => false)
      end
        
    end
    DiagnosticTestQuestion.create(:question_type => "ShortChoiceQuestion", :question_id => question.id, :diagnostic_test_id => diagnostic_test.id) 
  end

end
