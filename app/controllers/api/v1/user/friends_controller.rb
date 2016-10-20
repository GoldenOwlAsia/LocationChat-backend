class Api::V1::User::FriendsController < Api::V1::User::BaseController
  def index
    @old_friends = User.old_friends(current_user).page(params[:page] || 0).per(params[:limit] || 10)
    @new_friends = User.new_friends(current_user)
    @pending_friend = User.friends_pending(current_user)
    @total_count = current_user.friends.page(params[:page] || 0).per(params[:limit] || 10).total_count
    render json: { success: true, data: { old_friends: @old_friends, new_friends: @new_friends, pending_friend: @pending_friend }, total: @total_count }
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
    service = FriendRequestService.new current_user.id, status_params[:to_user_id]
    @data = service.send_request
    @to_user = User.find status_params[:to_user_id]
    if @data
      APNS.send_notification(@to_user.device_token, alert: "#{current_user.name} has sent you a friend request.", sound: "default", badge: 1)
      render json: { success: true, data: @data }, status: 201
    else
      render json: { success: false, error: service.last_error_message }, status: 422
    end
  end

  def accept_add_friend
    service = FriendRequestService.new current_user.id, status_params[:to_user_id]
    if service.accept_request
      render json: { success: true }, status: 201
    else
      render json: { success: false, error: service.last_error_message }, status: 422
    end
  end

  def reject_add_friend
    service = FriendRequestService.new current_user.id, status_params[:to_user_id]
    if service.reject_request
      render json: { success: true }, status: 201
    else
      render json: { success: false, error: service.last_error_message }, status: 422
    end
  end

  def send_message
    @to_user = User.find status_params[:to_user_id]
    @alert_msg = "#{current_user.name}: #{status_params[:message]}"
    APNS.send_notification(@to_user.device_token, alert: @alert_msg, other: { user_name: current_user.name, url: current_user.url_image_picture, id: current_user.id, msg: status_params[:message] })
    if current_user
      render json: { success: true }, status: 201
    else
      render json: { success: false }, status: 422
    end
  end

  private

  def status_params
    params.require(:friendship).permit(:to_user_id, :message)
  end

  def destroy_params
    params.require(:friendship).permit(:to_user_id)
  end
end
