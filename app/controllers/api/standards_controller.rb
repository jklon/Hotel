class Api::StandardsController < ApiController
  
  def get_standards
    @standards = Standard.includes(:subjects,:chapters).where(:standard_number => [6,7]).all
  end

end