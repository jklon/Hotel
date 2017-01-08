ShortChoiceQuestion.where(:standard_id => [1,2,4]).all.each do |scq|
  scq.update(:source_id => 1)
  scq.save!
end
ShortChoiceQuestion.where(:standard_id => [3,5]).all.each do |scq|
  scq.update(:source_id => 2)
  scq.save!
end