json.id                                     scq.id
json.question_text                          scq.question_text
json.question_image                         scq.question_image
json.hint_text                              scq.hint_text
json.answer_description                     scq.answer_description
json.topic_id                               scq.topic_id
json.second_topic_id                        scq.second_topic_id
json.stream_id                              scq.stream_id
json.chapter_id                             scq.chapter_id
json.subject_id                             scq.subject_id
json.standard_id                            scq.standard_id
json.hint_available                         scq.hint_available
json.passage_footer                         scq.passage_footer
json.passage                                scq.passage
json.correct_answer_id                      scq.correct_answer_id
json.passage_header                         scq.passage_header
json.reason                                 scq.reason
json.hint_image                             scq.hint_image
json.multiple_correct                       scq.multiple_correct
json.question_style                         scq.question_style
json.level                                  scq.level
json.answer                                 scq.answer
json.difficulty                             scq.difficulty
json.reference_solving_time                 scq.reference_solving_time
json.answers do
  json.array! scq.short_choice_answers, partial: 'api/short_choice_answers/show', as: :sca
end