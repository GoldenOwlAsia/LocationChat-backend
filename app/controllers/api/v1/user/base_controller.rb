class Api::V1::User::BaseController < Api::V1::BaseController
  before_action :authenticate_user_from_token!, :update_last_sign_in_at

  def current_user
    @user
  end

  private

  def authenticate_user_from_token!
    authenticate_from_token!(User)
  end

  def update_last_sign_in_at
    if user_signed_in? && !session[:logged_signin]
      sign_in(current_user, force: true)
      session[:logged_signin] = true
    end
  end

  def find_user_from_token
    token = request.headers['Authorization'].presence || params[:auth_token].presence
    @user = token && User.find_by(auth_token: token)
  end
end
