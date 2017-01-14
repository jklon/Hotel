class DiagnosticTestPersonalization < ActiveRecord::Base
  belongs_to :user
  belongs_to :diagnostic_test
end
