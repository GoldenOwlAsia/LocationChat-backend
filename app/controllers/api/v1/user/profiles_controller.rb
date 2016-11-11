class Api::V1::User::ProfilesController < Api::V1::User::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:check, :create]
  before_action :find_target_user, only: [:show, :update]
  def index
  end

  def show
    current_user.friend_requests.map(&:to_user).each do |to_user|
      @status = to_user.friend_requests.map(&:status).first if to_user.id == @target_user.id
    end
    render json: { success: true, data: UserSerializer.new(@target_user), status: @status }
  end

  def check
    @user = User.find_by(provider: check_params[:provider], uid: check_params[:uid])
    render json: { success: @user ? true : false }
  end

  def create
    @user = User.new(create_profile_params.except(:photos))
    if create_profile_params[:photos].present?
      create_profile_params[:photos].split(',').each do |photo|
        @user.photos.build(url: photo.strip)
      end
    end
    if @user.save
      render json: { success: true, data: UserSerializer.new(@user.reload) }, status: 201
    else
      render json: { success: false, error: @user.errors.full_messages.last }, status: 422
    end
  end

  def update
    if current_user != @target_user
      return render json: { success: false, error: "This profile isn't belongs to you" }, status: 200
    end
    current_user.attributes = update_profile_params.except(:photos)
    ActiveRecord::Base.transaction do
      if update_profile_params[:photos].present?
        current_user.destroy_photos
        update_profile_params[:photos].split(',').each do |photo|
          current_user.photos.build(url: photo.strip)
        end
      end
      @updated = current_user.save
    end
    if @updated
      render json: { success: true, data: UserSerializer.new(current_user) }, status: 200
    else
      render json: { success: false, error: current_user.errors.full_messages.last }, status: 422
    end
  end

  private

  def find_target_user
    @target_user = User.find(params[:id])
  end

  def check_params
    params.require(:profile).permit(:provider, :uid, :device_token)
  end

  def create_profile_params
    params.require(:profile).permit(:provider, :uid, :device_token, :first_name, :last_name, :number_phone,
      :email, :url_image_picture, :phone_country_code, :home_city, :location, :latitude, :longitude, :photos)
  end

  def update_profile_params
    params.require(:profile).permit(:first_name, :last_name, :device_token, :number_phone, :email,
      :url_image_picture, :phone_country_code, :home_city, :location, :latitude, :longitude, :photos)
  end
end
