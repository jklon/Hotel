i = 0
ShortChoiceQuestion.where("question_text like ? and standard_id = ?","%<img src%", 5).all.each do |question|
  text = question.question_text
	puts question.id
	image_url = text[(text.index('http'))..-1]
	image_url = image_url[0..(image_url.index('/>')-2)]
	final_text = text[0..(text.index('<img')-1)]
	question.answer_image = image_url
	question.question_text = final_text
	puts question.answer_image
	puts question.question_text
	question.save!
  i = i+1
end
