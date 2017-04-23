SecondTopic.all.each do |topic|

  chapter = Chapter.where(:id => topic.chapter_id).first
  stream = Stream.where(:id => chapter.stream_id).first
  puts topic.name
  puts stream.name
  puts
  topic.stream_id = stream.id
  topic.save!
end

ShortChoiceQuestion.where(:subject_id => [6,7,8,9,10,11]).each do |question|
	topic = SecondTopic.where(:id=>question.second_topic_id).first
	puts topic.name
	question.stream_id = topic.stream_id
	question.save!
end