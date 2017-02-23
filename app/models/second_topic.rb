class SecondTopic < ActiveRecord::Base
  belongs_to :subject
  belongs_to :standard
  belongs_to :chapter
  belongs_to :stream
  has_many :sub_topics
  has_many :short_choice_questions
  has_many :extra_marks_questions
  has_many :user_entity_scores, as: :entity
  has_many :user_current_standings, as: :entity

  has_many :children_second_topics, foreign_key: :parent_id, class_name: "SecondTopicTree" 
  has_many :children, through: :children_second_topics, source: :child

  has_many :parent_second_topics, foreign_key: :child_id, class_name: "SecondTopicTree"    
  has_many :parents, through: :parent_second_topics, source: :parent

  def stream_position
    self.id
  end

end
