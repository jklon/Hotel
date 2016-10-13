require 'rubyXL'

book = RubyXL::Parser.parse('/Users/neeraj/Documents/Mathematics_Paths.xlsx')
master_sheet = book[0]

count = 0
standard = Standard.find_by(:standard_number => 6)
subject  = Subject.where(:standard => standard, :name => "Maths").first
master_sheet.each do |row|
  
  stream_name = row.cells[3].value
  stream_code = row.cells[4].value
  chapter_name = row.cells[5].value
  chapter_code = row.cells[6].value
  topic_name = row.cells[7].value
  topic_code = row.cells[8].value


  if row.cells[0].value == 'C06' and row.cells[1].value == 'Maths'
    #Create or find stream
    if not stream = Stream.find_by(:name => stream_name)
      stream = Stream.create(:name => stream_name, :code => stream_code)
    end

    #Create or find chapter
    if not chapter = Chapter.find_by(:name => chapter_name)
      chapter = Chapter.create(:name => chapter_name, :code => chapter_code,
       :stream_id => stream.id, :subject => subject, :standard => standard)
    end

    # if not topic = Topic.find_by(:name => topic_name)
      topic = Topic.create(:name => topic_name, :code => topic_code,
       :stream_id => stream.id, :subject => subject, :standard => standard, :chapter => chapter)
    # end
  end
end
