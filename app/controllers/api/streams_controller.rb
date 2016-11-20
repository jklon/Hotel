class Api::StreamsController < ApiController
  
  def get_streams
    @streams = Stream.all
  end

end