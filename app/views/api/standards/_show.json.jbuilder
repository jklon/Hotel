json.standard_id standard.id
json.name standard.name
json.standard_number standard.standard_number
json.board standard.board
json.subjects do
  json.array! standard.subjects, partial: 'api/subjects/show', as: :subject
end