require 'rubyXL'

book = RubyXL::Parser.parse('scripts/Class-7-Mycbse-v1.2.xlsx')
scq_sheet = book[0]

standard    = Standard.where(:standard_number => 7).first
subject     = Subject.where(:standard => standard, :name => "Maths").first
stream      =  Stream.first
empty_row   = false
question    = ShortChoiceQuestion.first

#scq_sheet.each_with_index do |row, index|
#row = scq_sheet[1]
  row = scq_sheet[0]
  #next if index ==0
  if (row.cells[12])
    chapter = Chapter.find_by(:name => row.cells[14].value)
    stream = Stream.find_by(:id => chapter.stream_id)
    second_topic_name = row.cells[12].value
    second_topic = SecondTopic.where(:name => second_topic_name, :standard => standard, :subject => subject, :stream => stream, :chapter => chapter).first
    #puts second_topic_name if not second_topic
    second_topic = SecondTopic.create(:name => second_topic_name, :standard => standard, :subject => subject, :stream => stream, :chapter => chapter) if not second_topic
    
    question = ShortChoiceQuestion.create(:question_text => row.cells[1].value,:standard => standard, :subject => subject, :stream => stream, :second_topic => second_topic, :chapter => chapter)
    for i in 0..3
      row_count = (2*i)+5
      if(row.cells[row_count-1].value == row.cells[15].value)
        ShortChoiceAnswer.create(:short_choice_question => question,:answer_text => row.cells[row_count].value, :correct => true)
      else
        ShortChoiceAnswer.create(:short_choice_question => question,:answer_text => row.cells[row_count].value, :correct => false)
      end
        
    end
  end

#end