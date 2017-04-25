class UserWorksheetAttempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :worksheet
  belongs_to :second_topic
  belongs_to :sub_topic
  has_many :difficultywise_worksheet_breakups
  has_many :difficulty_levels, :through => :difficultywise_worksheet_breakups
  has_many :user_entity_scores, as: :test
end
