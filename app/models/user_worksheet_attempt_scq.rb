class UserWorksheetAttemptScq < ActiveRecord::Base
  belongs_to :short_choice_question
  belongs_to :user_worksheet_attempt
end
