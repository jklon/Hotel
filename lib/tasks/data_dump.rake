namespace :data_dump do
  task :excel_9 => :environment do 
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

  task :excel_8 => :environment do 
    workbook = RubyXL::Workbook.new
    sheet = workbook.worksheets[0]
    sheet.sheet_name = "8th"
    columns = ["id", "question_text", "answer_description", "Chapter Name","Topic Name", "level",  "difficulty",
      "answer 1", "answer 2", "answer 3", "answer 4", "answer 5"]
    columns.each_with_index{|v,i| sheet.add_cell(0,i,v)}
    ShortChoiceQuestion.where(:standard_id => 1, :subject_id => 6).includes(:chapter, :topic, :short_choice_answers).find_each.with_index do |q, i|
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
    workbook.write("/Users/neeraj/Documents/class-8-physics-questions.xlsx")
  end

  task :excel_10 => :environment do 
    workbook = RubyXL::Workbook.new
    sheet = workbook.worksheets[0]
    sheet.sheet_name = "10th"
    columns = ["id", "question_text", "answer_description", "Chapter Name","Topic Name", "level",  "difficulty",
      "answer 1", "answer 2", "answer 3", "answer 4", "answer 5"]
    columns.each_with_index{|v,i| sheet.add_cell(0,i,v)}
    ShortChoiceQuestion.where(:standard_id => 4).includes(:chapter, :topic, :short_choice_answers).find_each.with_index do |q, i|
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
    workbook.write("/Users/neeraj/Documents/class-10-questions.xlsx")
  end

  task :excel_6 => :environment do 
    workbook = RubyXL::Workbook.new
    sheet = workbook.worksheets[0]
    sheet.sheet_name = "6th"
    columns = ["id", "question_text", "answer_description", "Chapter Name","Topic Name", "level",  "difficulty",
      "answer 1", "answer 2", "answer 3", "answer 4", "answer 5"]
    columns.each_with_index{|v,i| sheet.add_cell(0,i,v)}
    ExtraMarksQuestion.where(:standard_id => 3).includes(:chapter, :topic, :extra_marks_answers).find_each.with_index do |q, i|
      sheet.add_cell(i+1, 0, q.id)
      sheet.add_cell(i+1, 1, q.question_text)
      sheet.add_cell(i+1, 2, q.answer_description)
      sheet.add_cell(i+1, 3, q.chapter.name)
      sheet.add_cell(i+1, 4, q.topic ? q.topic.name : "")
      sheet.add_cell(i+1, 5, q.level)
      sheet.add_cell(i+1, 6, q.difficulty)
      q.extra_marks_answers.each_with_index do |a, j|
        sheet.add_cell(i+1, 6+j+1, a.answer_text)
      end
    end
    workbook.write("/Users/neeraj/Documents/class-6-questions.xlsx")
  end

  task :excel_7 => :environment do 
    workbook = RubyXL::Workbook.new
    sheet = workbook.worksheets[0]
    sheet.sheet_name = "7th"
    columns = ["id", "question_text", "answer_description", "Chapter Name","Topic Name", "level",  "difficulty",
      "answer 1", "answer 2", "answer 3", "answer 4", "answer 5"]
    columns.each_with_index{|v,i| sheet.add_cell(0,i,v)}
    ExtraMarksQuestion.where(:standard_id => 4).includes(:chapter, :topic, :extra_marks_answers).find_each.with_index do |q, i|
      sheet.add_cell(i+1, 0, q.id)
      sheet.add_cell(i+1, 1, q.question_text)
      sheet.add_cell(i+1, 2, q.answer_description)
      sheet.add_cell(i+1, 3, q.chapter.name)
      sheet.add_cell(i+1, 4, q.topic ? q.topic.name : "")
      sheet.add_cell(i+1, 5, q.level)
      sheet.add_cell(i+1, 6, q.difficulty)
      q.extra_marks_answers.each_with_index do |a, j|
        sheet.add_cell(i+1, 6+j+1, a.answer_text)
      end
    end
    workbook.write("/Users/neeraj/Documents/class-7-questions.xlsx")
  end

end