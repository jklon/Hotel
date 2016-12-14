json.partial! 'show', worksheet: @worksheet
if @worksheet.subject
  json.subject do
    json.partial! 'api/subjects/show',  subject: @worksheet.subject
  end
end
if @worksheet.stream
  json.stream do
    json.partial! 'api/streams/show',  stream: @worksheet.stream
  end
end
if @worksheet.second_topic
  json.second_topic do
    json.partial! 'api/second_topics/show',  second_topic: @worksheet.second_topic
  end
end

if @worksheet_attempt
  json.partial! 'show_attempt', worksheet_attempt: @worksheet_attempt
end