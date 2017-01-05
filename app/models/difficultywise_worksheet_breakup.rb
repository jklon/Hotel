class DifficultywiseWorksheetBreakup < ActiveRecord::Base
  belongs_to :user_worksheet_attempt
  belongs_to :difficulty_level
end
