class Api::V1::User::ChannelsController < Api::V1::User::BaseController
  before_action :find_channel, only: [:update, :destroy, :show, :check_favorite, :uncheck_favorite]

  def index
    service = ChannelService.new current_user, params[:type]
    @channels = service.call
    if @channels.present?
      render json: { success: true, data: @channels.map { |x| ChannelSerializer.new(x, current_user) } }
    else
      render json: { success: true, data: [] }
    end
  end

  def check_favorite
    @channel_user = ChannelUser.where(user: current_user, channel: @channel).last
    if @channel_user.update_attributes(is_favorite: true)
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def uncheck_favorite
    @channel_user = ChannelUser.where(user: current_user, channel: @channel).last
    if @channel_user.update_attributes(is_favorite: false)
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def create
    service = Chat::ChannelService.new create_params[:user_ids], create_params
    channel = service.call
    if channel
      render json: { success: true, data: channel }, status: 201
    else
      render json: { success: false, error: service.errors.full_messages.last }, status: 422
    end
  end

  def update
    if @channel.update update_params
      render json: { success: true, data: @channel }, status: 200
    else
      render json: { success: false, error: service.errors.full_messages.last }, status: 422
    end
  end

  def show
    render json: { success: true, data: ChannelSerializer.new(@channel, current_user) }
  end

  def destroy
    if @channel.destroy
      render json: { success: true }, status: 200
    else
      render json: { success: false }, status: 400
    end
  end

  private

  def find_channel
    @channel ||= Channel.find params[:id]
  end

  def create_params
    params.require(:channel).permit(:twilio_channel_sid, :friendly_name, user_ids: [])
  end

  def update_params
    params.require(:channel).permit(:twilio_channel_sid, :friendly_name)
  end
end
