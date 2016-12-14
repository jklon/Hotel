class Api::HomepageController < ApiController

  skip_before_action :authenticate_user!
  protect_from_forgery :except => :get_streamwise_score


  def get_streamwise_score
  	user_params_sane? params[:user]
    @user = User.find_or_create_temp_user(params[:user])
    @stream = Stream.all;
  end
end
