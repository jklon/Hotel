class Api::UsersController < ApiController
  skip_before_action :authenticate_user!
  before_action :user_params_sane?, only: [:register]
  before_action -> { user_params_sane?(user_params) }, only: [:register]

  def register
    @errors = User.find_existing_on_register(user_params)
    
    if @errors
      render 'api/error' and return
    end

    if @user = User.build(user_params)
      render 'register_success'
    else
      render 'api/error'
    end
  end

  private
  def user_params
    params.require(:user).permit(:id, :first_name, :number, :email, :last_name)
  end

end