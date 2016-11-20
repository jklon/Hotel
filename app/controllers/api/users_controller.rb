class Api::UsersController < ApiController
  skip_before_action :authenticate_user!
  before_action -> { user_params_sane?(user_params) },, only: [:register]

  def register
    @errors = User.find_existing_on_register(user_params)
    
    if @errors
      render 'api/error' and return
    end

    @user = User.new(user_params)
    if @user.save
      render 'register_success'
    else
      @errors = @user.errors
      render 'api/error'
    end
  end

  private
  def user_params
    params.require(:user).permit(:id, :first_name, :number, :email, :last_name)
  end

end