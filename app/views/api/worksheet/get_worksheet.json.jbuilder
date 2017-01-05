json.partial! 'show', worksheet: @worksheet
json.questions do
  json.array! @worksheet.short_choice_questions, partial: 'api/short_choice_questions/show', as: :scq
end
if @worksheet_attempt
  json.partial! 'show_attempt', worksheet_attempt: @worksheet_attempt
end