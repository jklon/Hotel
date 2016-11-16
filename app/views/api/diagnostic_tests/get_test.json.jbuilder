json.partial! 'show', diagnostic_test: @diagnostic_test
json.questions do
  json.array! @diagnostic_test.short_choice_questions, partial: 'api/short_choice_questions/show', as: :scq
end