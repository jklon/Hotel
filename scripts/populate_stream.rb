SecondTopic.all.each do |topic|

  chapter = Chapter.where(:id => topic.chapter_id).first
  stream = Stream.where(:id => chapter.stream_id).first
  puts topic.name
  puts stream.name
  puts
  topic.stream_id = stream.id
  topic.save!
end
