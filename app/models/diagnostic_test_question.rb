class DiagnosticTestQuestion < ActiveRecord::Base
  belongs_to :diagnostic_test
  belongs_to :question, :polymorphic => true
end
