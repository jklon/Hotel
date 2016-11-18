class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: false, email: true, allow_blank: true

  def find_existing_on_register user_params
    if user_params[:number]
      user = UserPhoneNumber.find_by_number(user_params[:number])
      return {:number => "already exists"} if user
    end

    if user_params[:email]
      user = User.find_by_email(user_params[:email])
      return {:email => "already taken"} if user
    end

    return false
  end

  def build(user_params)

  end

  private

end
