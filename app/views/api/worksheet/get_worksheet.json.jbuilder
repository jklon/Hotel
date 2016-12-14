json.partial! 'show', worksheet: @worksheet
json.questions do
  json.array! @worksheet.short_choice_questions, partial: 'api/short_choice_questions/show', as: :scq
end