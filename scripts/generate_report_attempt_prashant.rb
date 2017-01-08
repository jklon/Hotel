require 'rubyXL'

# book = RubyXL::Parser.parse('/home/ec2-user/Mathematics_Paths.xlsx')
# master_sheet = book[0]

attempt_counter =0
question_counter =0
answer_counter = 0
DiagnosticTestAttempt.where.not(user_id: nil).all.each do |attempt|
  user = User.where(:id => attempt.user_id).first
  diagnostic_test = DiagnosticTest.where(:id => attempt.diagnostic_test_id).first
  
  puts "User Name "+user.first_name+" "+ user.last_name if user.first_name
  puts "Diagnostic Test Name "+diagnostic_test.name if (diagnostic_test)&&(diagnostic_test.name)

  DiagnosticTestAttemptScq.where(:diagnostic_test_attempt_id => attempt.id).all.each do |question|
    scq = ShortChoiceQuestion.where(:id => question.short_choice_question_id).first
    user_answer = ShortChoiceAnswer.where(:id => question.short_choice_answer_id).first

    puts "Question text "+ scq.question_text if scq && scq.question_text
    puts "Answer text select by User "+ user_answer.answer_text if (user_answer)&&(user_answer.answer_text) 
    puts "Time taken by User "+ question.time_spent.to_s if question.time_spent
    puts "Result of user attempt "+ question.attempt.to_s if question.attempt
    
    DiagnosticTestAttemptScqSca.where(:diagnostic_test_attempt_scq_id => question.id).all.each do |answer|
      selected_answer = ShortChoiceAnswer.where(:id => answer.short_choice_answer_id).first

      puts "Option selected by User "+ selected_answer.answer_text if (selected_answer)&&(selected_answer.answer_text) 
      puts "Time taken by User for selecting this option "+ answer.time_spent.to_s if answer.time_spent
      puts "Attempt order of selecting this option "+ answer.attempt_order.to_s if answer.attempt_order
    end
  
  end

end
