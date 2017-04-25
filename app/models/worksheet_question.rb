class WorksheetQuestion < ActiveRecord::Base
  belongs_to :worksheet
  belongs_to :question, :polymorphic => true
end
