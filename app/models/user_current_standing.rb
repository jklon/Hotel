class UserCurrentStanding < ActiveRecord::Base
  belongs_to :user
  belongs_to :entity, polymorphic: true
  belongs_to :stream
end
