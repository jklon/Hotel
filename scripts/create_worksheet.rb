Chapter.where(:standard_id => 2).each do |c|
  topics = SecondTopic.where(:chapter => c)
  topics.each do |t|
    worksheet = Worksheet.create(:second_topic_id => t.id, :chapter_id => t.chapter_id, :stream_id => t.stream_id, :standard_id => t.standard_id, :subject_id => t.subject_id)
    ids = t.short_choice_questions.where(:level => [1,2]).limit(20).pluck(:id)
    ids += t.short_choice_questions.where(:level => [3]).limit(20).pluck(:id)
    ids += t.short_choice_questions.where(:level => [4,5]).limit(20).pluck(:id)
    ids.each do |id|
    	WorksheetScq.create(:question_type => "ShortChoiceQuestion", :question_id => id, :worksheet_id => worksheet.id)
    end
  end
end
