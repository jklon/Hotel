require 'rubyXL'

book = RubyXL::Parser.parse('scripts/Prashant_Report.xlsx')
master_sheet = book[0]
row = master_sheet[0]





row_count =0
master_sheet.add_cell( row_count,0, "Username")
master_sheet.add_cell( row_count,1, "Diagnostic Test") 
master_sheet.add_cell( row_count,2, "Diagnostic Test Id")
master_sheet.add_cell( row_count,3, "Question Text") 
master_sheet.add_cell( row_count,4, "Answer selected") 
master_sheet.add_cell( row_count,5, "Total time spent on question")
master_sheet.add_cell( row_count,6, "Result Flag")
master_sheet.add_cell( row_count,7, "Answer Selected")
master_sheet.add_cell( row_count,8, "Time spent to select this option")
master_sheet.add_cell( row_count,9, "Answer Selection order")
row_count = row_count +1;
DiagnosticTestAttempt.where.not(user_id: nil).all.each do |attempt|
  user = User.where(:id => attempt.user_id).first
  diagnostic_test = DiagnosticTest.where(:id => attempt.diagnostic_test_id).first
  
  
  puts "User Name "+user.first_name+" "+ user.last_name if user.first_name
  puts "Diagnostic Test Name "+diagnostic_test.name if (diagnostic_test)&&(diagnostic_test.name)

  if user.first_name && (diagnostic_test)&&(diagnostic_test.name)
    master_sheet.add_cell( row_count,0, user.first_name)
    master_sheet.add_cell( row_count,1, diagnostic_test.name) if (diagnostic_test)&&(diagnostic_test.name)
    master_sheet.add_cell( row_count,2, diagnostic_test.id) if (diagnostic_test)

    DiagnosticTestAttemptScq.where(:diagnostic_test_attempt_id => attempt.id).all.each do |question|
      scq = ShortChoiceQuestion.where(:id => question.short_choice_question_id).first
      user_answer = ShortChoiceAnswer.where(:id => question.short_choice_answer_id).first

      puts "Question text "+ scq.question_text if scq && scq.question_text
      puts "Answer text select by User "+ user_answer.answer_text if (user_answer)&&(user_answer.answer_text) 
      puts "Time taken by User "+ question.time_spent.to_s if question.time_spent
      puts "Result of user attempt "+ question.attempt.to_s if question.attempt

      if scq && scq.question_text && question.time_spent && question.attempt
        master_sheet.add_cell( row_count,3, scq.question_text)
        master_sheet.add_cell( row_count,4, user_answer.answer_text) if (user_answer)&&(user_answer.answer_text) 
        master_sheet.add_cell( row_count,5, question.time_spent.to_s)
        master_sheet.add_cell( row_count,6, question.attempt.to_s)
        
        
        DiagnosticTestAttemptScqSca.where(:diagnostic_test_attempt_scq_id => question.id).all.each do |answer|
          selected_answer = ShortChoiceAnswer.where(:id => answer.short_choice_answer_id).first

          puts "Option selected by User "+ selected_answer.answer_text if (selected_answer)&&(selected_answer.answer_text) 
          puts "Time taken by User for selecting this option "+ answer.time_spent.to_s if answer.time_spent
          puts "Attempt order of selecting this option "+ answer.attempt_order.to_s if answer.attempt_order

          master_sheet.add_cell( row_count,7, selected_answer.answer_text) if (selected_answer)&&(selected_answer.answer_text) 
          master_sheet.add_cell( row_count,8, answer.time_spent.to_s) if answer.time_spent
          master_sheet.add_cell( row_count,8, answer.attempt_order.to_s) if answer.attempt_order
          row_count = row_count +1;
        end
      end
    end
    row_count = row_count +1;
  end

end
book.save
puts master_sheet[0][0].value