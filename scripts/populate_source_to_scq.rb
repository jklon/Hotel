ShortChoiceQuestion.where(:standard_id => [1,2,4]).update_all(:source_id => 1)
ShortChoiceQuestion.where(:standard_id => [3,5]).update_all(:source_id => 2)