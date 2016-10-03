class Api::V1::User::Channels::MembersController < Api::V1::User::Channels::BaseController
  def index
    render json: { success: true, data: @channel.users.map { |x| UserSerializer.new(x) } }
  end

  def create
    user = User.find params[:user_id]
    if @channel.channel_users.where(user_id: user.id).count > 0
      render json: { success: true }
    else
      @channel.channel_users << ChannelUser.new(user: user)
      if @channel.save
        render json: { success: true }
      else
        render json: { success: false, error: @channel.errors.full_messages.last }, status: 422
      end
    end
  end

  def destroy
    channel_user = @channel.channel_users.where(id: params[:user_id]).last
    channel_user.destroy if channel_user.present?
    render json: { success: true }
  end
end
