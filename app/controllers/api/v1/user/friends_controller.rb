class Api::V1::User::FriendsController < Api::V1::User::BaseController
  def index
    @friends = current_user.friends
    render json: { success: true, data: @friends }
  end

  def create
    service = FriendshipService.new current_user.id, create_params[:to_user_id]
    if service.call
      render json: { success: true }, status: 201
    else
      render json: { success: false, error: service.last_error_message }, status: 422
    end
  end

  def destroy
  end

  private

  def create_params
    params.require(:friendship).permit(:to_user_id)
  end
end