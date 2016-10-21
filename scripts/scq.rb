require 'rubyXL'

book = RubyXL::Parser.parse('/home/ec2-user/questions.xlsx')
scq_sheet = book[0]

standard    = Standard.find_by(:standard_number => 6)
subject     = Subject.where(:standard => standard, :name => "Maths").first
stream      =  Stream.first
empty_row   = false
question    = ShortChoiceQuestion.first

scq_sheet.each_with_index do |row, index|
  if empty_row
    empty_row = false
    next
  end

  if row[0].value
    if row[1].value
      row.cells.each do |a|
        next if not a.value
        temp = a.value.split(")", 2).count == 2 ? a.value.split(")", 2)[1].gsub(/\A\p{Space}*/, '') : a.value.gsub(/\A\p{Space}*/, '')
        ShortChoiceAnswer.create(:short_choice_question => question,
       :answer_text => temp)
      end
    else
      temp = row[0].value.split(".", 2).count == 2 ? row[0].value.split(".", 2)[1] : row[0].value
      question = ShortChoiceQuestion.create(:question_text => temp.gsub(/\A\p{Space}*/, ''),
        :standard => standard, :subject => subject, :stream => stream)
    end    
  else 
    stream = Stream.find_by(:name => scq_sheet[index + 1][0].value.gsub(/\A\p{Space}*/, ''))
    empty_row = true
  end
end
