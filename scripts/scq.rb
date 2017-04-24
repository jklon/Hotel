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
