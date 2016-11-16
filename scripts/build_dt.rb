Chapter.where(:standard_id => 2).each do |c|
  c.second_topics.each do |t|
    ids = t.short_choice_questions.where(:level => [2,3]).pluck(:id)
    next if ids.count < 30
    first = ids[rand(ids.count + 1)]
    second = ids[rand(ids.count + 1)]
    second = ids[rand(ids.count + 1)] if first == second

    DiagnosticTestQuestion.create(:question_type => "ShortChoiceQuetion", :question_id => first, :diagnostic_test_id => 1)
    DiagnosticTestQuestion.create(:question_type => "ShortChoiceQuetion", :question_id => second, :diagnostic_test_id => 1)

  end
end