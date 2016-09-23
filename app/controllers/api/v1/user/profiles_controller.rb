class Api::V1::User::ProfilesController < Api::V1::User::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:check]
  before_action :find_user, only: [:show]
  def index
  end

  def show
    render json: Api::V1::UserSerializer.new(@user).to_json
  end

  def check
    @user = User.find_by provider: check_params[:provider], uid: check_params[:uid], device_token: check_params[:device_token]
    if @user
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  private

  def find_user
    @user = User.find params[:id]
  end

  def check_params
    params.require(:profile).permit(:provider, :uid, :device_token)
  end
end
