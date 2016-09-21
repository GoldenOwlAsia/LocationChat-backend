# frozen_string_literal: true
class Api::V1::User::OauthsController < Api::V1::User::BaseController

  skip_before_action :authenticate_User_from_token!

  def create
    result = Oauth::LoginService.new(Oauth::Authenticator.new(oauth_params), User, user_params).call

    if result.success?
      @user = result.data || User.new
      render template: 'api/v1/user/sessions/create'
    else
      render json: { errors: result.errors.full_messages }, status: 400
    end
  end

  private

  def oauth_params
    params.require(:oauth).permit(:provider, :uid, :oauth_token)
  end

  def user_params
    params[:user].present? ? params.require(:user).permit(:name, :email) : nil
  end

end
