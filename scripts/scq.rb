require 'rubyXL'

book = RubyXL::Parser.parse('scripts/game_examples.xlsx')
scq_sheet = book[0]


empty_row   = false
question    = ShortChoiceQuestion.first

scq_sheet.each_with_index do |row, index|
  next if index ==0
  standard    = Standard.find_by(:standard_number => row.cells[0].value[2])
  subject     = Subject.where(:standard => standard, :name => row.cells[1].value).first
  stream      = Standard.find_by(:name => row.cells[3].value)
  chapter     = Chapter.find_by(:name => row.cells[6].value)
  second_topic= SecondTopic.find_by(:name => row.cells[9].value)
  sub_topic = SubTopic.find_by(:name => row.cells[11].value)
  if !sub_topic
    sub_topic = SubTopic.create(:name=> row.cells[9].value, :subject => subject, :standard => standard,:stream => stream, :chapter => chapter, :second_topic => second_topic)
  end
  question_style = QuestionStyle.find_by(:name => row.cells[11].value)
  if !question_style
    question_style = QuestionStyle.create(:name=> row.cells[11].value, :alias => row.cells[12].value)
  end
  workbook = Workbook.find_by(:question_style => question_style, :sub_topic => sub_topic)
  if !workbook
    workbook = Workbook.create(:question_style=> question_style, :sub_topic => sub_topic)
  end
  question_text = ""
  question.text = row.cells[13].value if row.cells[13]
  question = ShortChoiceQuestion.create(:question_text => question_text,
    :standard => standard, :subject => subject, :stream => stream, :second_topic => second_topic,
    :sub_topic => sub_topic, :question_style => question_style :sequence => row.cells[12].value)
  count = 14
  while row.cells[count]
    ShortChoiceAnswer.create(:short_choice_question => question,
       :answer_text => row.cells[count+1])
    count = count+2
  end
end



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
    count = 17
    count = 18 if row.cells[13].value == "TrueFalse"
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
         :answer_text => row.cells[count].value.to_s)
        answer.correct = (row.cells[count+1].value.to_i==1)?true:false
        count = count+2
      when "Estimation"
        puts "Estimation: answer text is " +row.cells[count].value.to_s
        answer = ShortChoiceAnswer.create(:short_choice_question => question,
         :answer_text => row.cells[count].value.to_s)
        count = count+1
      when "TrueFalse"
        puts "TrueFalse: correct answer text is " +row.cells[17].value.to_s
        answer = ShortChoiceAnswer.create(:short_choice_question => question,
         :answer_text => row.cells[count].value.to_s,:correct => false)
        count = count+1
        answer.correct = true if row.cells[17].value.to_i == (count-17)
      when "ShortChoice"
        puts "ShortChoice: correct answer text is " +row.cells[17].value.to_s
        answer = ShortChoiceAnswer.create(:short_choice_question => question,
         :answer_text => row.cells[count].value.to_s,:correct => false)
        count = count+1
        answer.correct = true if row.cells[17].value.to_i == (count-17)
      else
        count = count+1
      end
      # ShortChoiceAnswer.create(:short_choice_question => question,
      #    :answer_text => row.cells[count+1])
      # count = count+2
    end
  end
end
###################
Generating excel sheet based on short choice question filters
require 'rubyXL'

book = RubyXL::Parser.parse('scripts/generate_short_choice_question.xlsx')
scq_sheet = book[0]
row = scq_sheet[1]

ShortChoiceQuestion.where(:question_style => "blank").where(:second_topic_id => 57).each do |q|
  master_sheet.add_cell( row,0, q.standard.name)
  puts "Standard: "+q.standard.name
  master_sheet.add_cell( row,1, q.subject.name)
  puts "subject: "+q.subject.name
  master_sheet.add_cell( row,3, q.stream.name)
  puts "stream: "+q.stream.name
  master_sheet.add_cell( row,9, q.second_topic.name)
  puts "second_topic: "+q.second_topic.name
  master_sheet.add_cell( row,13, q.subject.name)
  puts "question_style: "+q.question_style
  master_sheet.add_cell( row,15, q.question_text)
  puts "question_text: "+q.question_text
  if q.hint_text
    master_sheet.add_cell( row,16, q.hint_text)
    puts "question_text: "+q.hint_text 
  end
  count = 17
  count = 18 if q.question_style == "TrueFalse" || q.question_style == "short choice"
  ShortChoiceAnswer.where(:short_choice_question => q).each do |ans|
    puts case ans.question_style
    when "blank"

    when "TrueFalse"
      master_sheet.add_cell( row,17, count-17) if ans.correct
      master_sheet.add_cell( row,count, ans.answer_text)
      count = count+1
    when "ShortChoice"
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
book.save!