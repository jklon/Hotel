require 'rubyXL'
book = RubyXL::Parser.parse('/Users/neeraj/Downloads/class-9-questions.xlsx')
master_sheet = book[0]



standard_id = 2
subject_id = 2
chapters = {}
check = true

master_sheet.each do |row|
  if check
    check = false
    next
  end

  scq = ShortChoiceQuestion.find(row.cells[0].value)

  second_topic_name = row.cells[4].value
  second_topic = SecondTopic.where(:name => second_topic_name, :standard_id => standard_id, :subject_id => subject_id, :chapter => scq.chapter).first
  
  puts second_topic_name if not second_topic

  second_topic = SecondTopic.create(:name => second_topic_name, :standard_id => standard_id, :subject_id => subject_id, :chapter => scq.chapter) if not second_topic

  scq.update(:second_topic => second_topic)

end