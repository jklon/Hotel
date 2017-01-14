# Chapter.where(:standard_id => 2).each do |c|
#   topics = SecondTopic.where(:chapter => c).joins(:short_choice_questions).group("second_topics.id").order("count(second_topics.id) DESC").limit(2)


#   topics.each do |t|
#     ids = t.short_choice_questions.where(:level => [2,3]).pluck(:id)
#     first = ids[rand(ids.count + 1)]
#     # second = ids[rand(ids.count + 1)]
#     # second = ids[rand(ids.count + 1)] if first == second

#     DiagnosticTestQuestion.create(:question_type => "ShortChoiceQuestion", :question_id => first, :diagnostic_test_id => 1)
#     # DiagnosticTestQuestion.create(:question_type => "ShortChoiceQuestion", :question_id => second, :diagnostic_test_id => 1)

#   end
# end
standard_number =6
standard =  Standard.where(:standard_number => standard_number).first
diagnostic_test = DiagnosticTest.create(:standard_id => standard.id,:subject_id => standard.id)
Chapter.where(:standard_id => standard.id).each do |c|
  ids = c.short_choice_questions.pluck(:id)
  first = ids[rand(ids.count + 1)]
  DiagnosticTestQuestion.create(:question_type => "ShortChoiceQuestion", :question_id => first,
   :diagnostic_test_id => diagnostic_test.id,, :diagnostic_test_type => "General") if first
end