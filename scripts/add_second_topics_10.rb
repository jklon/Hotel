require 'rubyXL'
book = RubyXL::Parser.parse('scripts/class-10-questions-second-topic.xlsx')
master_sheet = book[0]



standard_id = 4
subject_id = 1
chapters = {}
check = true
count = 0
master_sheet.each do |row|
  if check
    check = false
    next
  end

  scq = ShortChoiceQuestion.find(row.cells[0].value)

  if not scq
    count = count + 1
    next
  end

  next if not row.cells[12]
  second_topic_name = row.cells[12].value
  second_topic = SecondTopic.where(:name => second_topic_name, :standard_id => standard_id, :subject_id => subject_id, :chapter => scq.chapter).first
  puts second_topic_name if not second_topic
  second_topic = SecondTopic.create(:name => second_topic_name, :standard_id => standard_id, :subject_id => subject_id, :chapter => scq.chapter) if not second_topic
  scq.update(:second_topic => second_topic)
end


