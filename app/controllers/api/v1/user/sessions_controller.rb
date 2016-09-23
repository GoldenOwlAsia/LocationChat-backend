# frozen_string_literal: true
class Api::V1::User::SessionsController < Api::V1::User::BaseController

  skip_before_action :authenticate_user_from_token!, only: [:create]
  skip_before_action :verify_authenticity_token

  def create
    result = Oauth::LoginService.new(Oauth::Authenticator.new(sessions_params), User, nil).call
    if result.success?
      @user = result.data || User.new
      render json: { success: true, data: Api::V1::UserSerializer.new(@user) }
    else
      render json: { success: false, error: 'invalid credentials' }, status: 401
    end
  end

  def destroy
    if current_user.update(auth_token: nil)
      render json: { success: true }, status: 200
    else
      render json: { success: false }, status: 400
    end
  end

  private

  def sessions_params
    params.require(:session).permit(:provider, :uid, :device_token)
  end


end
