namespace :data_dump do
  task :excel_8 => :environment do 
    workbook = RubyXL::Workbook.new
    sheet = workbook.worksheets[0]
    sheet.sheet_name = "9th"
    columns = ["id", "question_text", "answer_description", "Chapter Name","Topic Name", "level",  "difficulty",
      "answer 1", "answer 2", "answer 3", "answer 4", "answer 5"]
    columns.each_with_index{|v,i| sheet.add_cell(0,i,v)}
    ShortChoiceQuestion.where(:standard_id => 2).includes(:chapter, :topic, :short_choice_answers).find_each.with_index do |q, i|
      sheet.add_cell(i+1, 0, q.id)
      sheet.add_cell(i+1, 1, q.question_text)
      sheet.add_cell(i+1, 2, q.answer)
      sheet.add_cell(i+1, 3, q.chapter.name)
      sheet.add_cell(i+1, 4, q.topic.name)
      sheet.add_cell(i+1, 5, q.level)
      sheet.add_cell(i+1, 6, q.difficulty)
      q.short_choice_answers.each_with_index do |a, j|
        sheet.add_cell(i+1, 6+j+1, a.answer_text)
      end
    end
    workbook.write("/Users/neeraj/Documents/class-9-questions.xlsx")
  end
end