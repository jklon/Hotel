class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable, :confirmable,
  #        :recoverable, :rememberable, :trackable, :validatable
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: false, email: true, allow_blank: true

  has_many :user_phone_numbers
  has_many :diagnostic_test_attempts
  has_many :user_current_standings
  has_many :diagnostic_test, through: :diagnostic_test_attempts

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

  def self.find_or_create_temp_user user_params
    if user_params[:auth_token]
      user = self.find_by_auth_token user_params[:auth_token]
      return user if user
    end

    if user_params[:number]
      user = self.find_by_phone_number(user_params[:number])
      return user if user

    end

    if user_params[:email]
      user = self.find_by_email(user_params[:email])
      return user if user
    end

    user = User.create!(:first_name => user_params[:first_name],
     :email => user_params[:email], :last_name => user_params[:last_name])
    UserPhoneNumber.create(:number => user_params[:number], :user => user)
    return user

  end

  def self.find_by_auth_token auth_token
    if auth_object = AuthToken.find_by_auth_token(auth_token) and user = auth_object.user
      return user
    else
      return false
    end
  end

  def self.find_by_phone_number number
    if cph = UserPhoneNumber.find_by_number(number) and user = cph.user
      return user
    else
      return false
    end
  end

  def generate_auth number
    AuthToken.create(:device_id => device_id, :number => number, :otp => token, :user => self)
  end

  def confirm device_id, number, token
    self.confirmed_at = Time.now
    self.save!
    self.generate_auth device_id, number, token
  end

  private

end
