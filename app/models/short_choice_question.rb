class ShortChoiceQuestion < ActiveRecord::Base
  has_many :short_choice_answers
  belongs_to :subject
  belongs_to :standard
  belongs_to :chapter
  belongs_to :topic
  belongs_to :second_topic
  belongs_to :stream
  belongs_to :sub_topic
  has_many :diagnostic_test_questions, :as => :question
  has_many :diagnostic_tests, :through => :diagnostic_test_questions
  accepts_nested_attributes_for :short_choice_answers, :allow_destroy => true

  filterrific(
    default_filter_params: { with_difficulty: 'easy' },
    available_filters: [
      :with_chapter_id,
      :with_topic_id,
      :with_standard_id,
      :with_subject_id,
      :with_difficulty,
      :with_level,
      :with_id
    ]
  )

  scope :with_id, lambda{ |query|
    where(:id => query)
  }

  scope :with_level, lambda {|query|
    where(:level => query)
  }
  scope :with_topic_id, lambda {|query|
    where(:topic_id => query)
  }
  scope :with_standard_id, lambda {|query|
    where(:standard_id => query)
  }
  scope :with_chapter_id, lambda {|query|
    where(:chapter_id => query)
  }
  scope :with_difficulty, lambda {|query|
    where(:difficulty => query)
  }
  scope :with_subject_id, lambda {|query|
    where(:subject_id => query)
  }

  def self.options_for_difficulty
    [
      ['Easy', 'easy'],
      ['Medium', 'medium'],
      ['Hard', 'hard']
    ]
  end

  def self.options_for_levels
    levels = []
    (1..5).each{|i| levels << [i,i]}
    levels
  end

  def self.options_for_standards
    Standard.all.pluck(:name, :id)
  end

  def self.options_for_chapters standard_id
    if !standard_id
      Chapter.all.pluck(:name, :id)
    else
      Chapter.where(:standard_id => standard_id).pluck(:name, :id)
    end
  end

  def self.options_for_topics chapter_id
    if !chapter_id
      Topic.all.pluck(:name, :id)
    else
      Topic.where(:chapter_id => chapter_id).pluck(:name, :id)
    end
  end

end
