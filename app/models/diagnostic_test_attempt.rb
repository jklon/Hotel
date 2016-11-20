class DiagnosticTestAttempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :diagnostic_test

  def evaluate_test question_answers
    stream_hash = {}
    ShortChoiceQuestion.where(:id => question_answers.keys).includes(:stream, :second_topic).each do |q|
      stream_hash[q.stream_id] ||= {'other_details' => {'stream_name' => q.stream.name}, 'second_topics' => {}}
      stream_hash[q.stream_id]['second_topics'][q.second_topic_id] ||= {}
      stream_hash[q.stream_id]['second_topics'][q.second_topic_id] = {'score' => question_answers[q.id.to_s]['score'],
      'second_topic_name' => q.second_topic.name}
      
      if question_answers[q.id.to_s]['score'] == 0
        new_lowest_position = q.second_topic.stream_position
        existing_lowest_position = stream_hash[q.stream_id]['other_details']['lowest_position']
        if ( not existing_lowest_position ) or ( new_lowest_position < existing_lowest_position.to_i )
          stream_hash[q.stream_id]['other_details']['lowest_second_topic_id'] = q.second_topic_id
          stream_hash[q.stream_id]['other_details']['lowest_position'] = new_lowest_position
        end
      end
    end
    return stream_hash
  end
end
