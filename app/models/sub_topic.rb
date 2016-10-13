class SubTopic < ActiveRecord::Base
  belongs_to :subject
  belongs_to :standard
  belongs_to :chapter
  belongs_to :topic
end
