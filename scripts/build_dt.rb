Chapter.where(:standard_id => 2).each do |c|
  topics = SecondTopic.where(:chapter => c).joins(:short_choice_questions).group("second_topics.id").order("count(second_topics.id) DESC").limit(2)


  topics.each do |t|
    ids = t.short_choice_questions.where(:level => [2,3]).pluck(:id)
    first = ids[rand(ids.count + 1)]
    # second = ids[rand(ids.count + 1)]
    # second = ids[rand(ids.count + 1)] if first == second

    DiagnosticTestQuestion.create(:question_type => "ShortChoiceQuestion", :question_id => first, :diagnostic_test_id => 1)
    # DiagnosticTestQuestion.create(:question_type => "ShortChoiceQuestion", :question_id => second, :diagnostic_test_id => 1)

  end
end