class Api::V1::User::ProfilesController < Api::V1::User::BaseController
  before_action :find_user, only: [:show]
  def index
  end

  def show
    render json: Api::V1::UserSerializer.new(@user).to_json
  end

  private

  def find_user
    @user = User.find params[:id]
  end
end
