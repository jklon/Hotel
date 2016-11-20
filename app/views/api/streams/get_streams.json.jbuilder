json.streams do
  json.array! @streams, partial: 'show', as: :stream
end