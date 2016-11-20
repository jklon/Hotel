class Api::StandardsController < ApiController
  
  def get_standards
    @standards = Standard.includes(:subjects).all
  end

end