class Api::StreamsController < ApiController
  
  def get_streams
    @streams = Stream.where("name LIKE :prefix", prefix: "s%")
  end

end