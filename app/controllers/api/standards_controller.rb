class Api::StandardsController < ApiController
  
  def get_standards
    @standards = Standard.all
  end

end