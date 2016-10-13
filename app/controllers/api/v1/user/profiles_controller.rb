class Api::V1::User::ProfilesController < Api::V1::User::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:check, :create]
  before_action :find_user, only: [:show]
  def index
  end

  def show
    render json: { success: true, data: UserSerializer.new(@user) }
  end

  def check
    @user = User.find_by provider: check_params[:provider], uid: check_params[:uid], device_token: check_params[:device_token]
    if @user
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def create
    @user = User.new create_profile_params.except(:photos)
    create_profile_params[:photos].split(',').map(&:strip).each do |photo|
      @user.photos.build url: photo
    end if create_profile_params[:photos].present?
    if @user.save
      render json: { success: true, data: UserSerializer.new(@user.reload) }, status: 201
    else
      render json: { success: false, error: @user.errors.full_messages.last }, status: 422
    end
  end

  def update
    @user = current_user
    @user.attributes = update_profile_params.except :photos
    update_profile_params[:photos].split(',').map(&:strip).each do |photo|
      @user.photos.build url: photo
    end if update_profile_params[:photos].present?
    if @user.save
      render json: { success: true, data: UserSerializer.new(@user.reload) }, status: 200
    else
      render json: { success: false, error: @user.errors.full_messages.last }, status: 422
    end
  end

  private

  def find_user
    @user = User.find params[:id]
  end

  def check_params
    params.require(:profile).permit(:provider, :uid, :device_token)
  end

  def create_profile_params
    params.require(:profile).permit(:provider, :uid, :device_token, :first_name, :last_name, :number_phone, :email, :url_image_picture, :phone_country_code, :home_city, :location, :latitude, :longitude, :photos)
  end

  def update_profile_params
    params.require(:profile).permit(:first_name, :last_name, :number_phone, :email, :url_image_picture, :phone_country_code, :home_city, :location, :latitude, :longitude, :photos)
  end
end
