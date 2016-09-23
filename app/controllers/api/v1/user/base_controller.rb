class Api::V1::User::BaseController < Api::V1::BaseController
  before_action :authenticate_user_from_token!

  def current_user
    @user
  end

  private

  def authenticate_user_from_token!
    authenticate_from_token!(User)
  end

  def find_user_from_token
    token = request.headers['Authorization'].presence || params[:auth_token].presence
    @user = token && User.find_by(auth_token: token)
  end
end
