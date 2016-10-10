class Api::V1::User::FriendsController < Api::V1::User::BaseController
  def index
    @friends = current_user.friends.page(params[:page] || 0).per(params[:limit] || 10)
    @total_count = @friends.total_count
    render json: { success: true, data: @friends, total: @total_count }
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

  def send_add_friend
    service = FriendshipService.new current_user.id, status_params[:to_user_id]
    if service.send_request
      render json: { success: true }, status: 201
    else
      render json: { success: false, error: service.last_error_message }, status: 422
    end
  end

  def accept_add_friend
    service = FriendshipService.new current_user.id, status_params[:to_user_id]
    if service.accept_request
      render json: { success: true }, status: 201
    else
      render json: { success: false, error: service.last_error_message }, status: 422
    end
  end

  private

  def create_params
    params.require(:friendship).permit(:to_user_id)
  end

  def status_params
    params.require(:friendship).permit(:to_user_id)
  end

  def destroy_params
    params.require(:friendship).permit(:to_user_id)
  end
end
