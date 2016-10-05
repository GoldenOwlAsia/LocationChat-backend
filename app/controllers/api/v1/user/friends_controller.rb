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
    frienships = Friendship.in_friendship(current_user.id, destroy_params[:user_id])
    if frienships.destroy_all
      render json: { success: true }, status: 201
    else
      render json: { success: false, error: 'Unable to delete friendship' }, status: 422
    end
  end

  private

  def create_params
    params.require(:friendship).permit(:to_user_id)
  end

  def destroy_params
    params.require(:friendship).permit(:to_user_id)
  end
end
