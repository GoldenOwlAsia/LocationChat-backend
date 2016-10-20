class Api::V1::User::ChannelsController < Api::V1::User::BaseController
  before_action :find_channel, only: [:update, :destroy, :show, :check_favorite, :uncheck_favorite]

  def index
    service = ChannelService.new current_user, params[:type]
    channels = service.call
    if channels.present?
      if params[:type] == Constants::ChannelTypes::GROUPS
        data = { favorite: serialize(channels[:favorite], current_user),
                    within_radius: serialize(channels[:within_radius], current_user),
                    outside_radius: serialize(channels[:outside_radius], current_user) }
      else
        data = serialize(channels, current_user)
      end
      render json: { success: true, data: data }
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
    user_ids = create_params[:user_ids].split(',').map(&:strip).map(&:to_i)
    service = Chat::ChannelService.new user_ids, create_params
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
    params.require(:channel).permit(:twilio_channel_sid, :friendly_name, :user_ids)
  end

  def update_params
    params.require(:channel).permit(:twilio_channel_sid, :friendly_name)
  end

  def serialize(arr, user)
    arr.map { |x| ChannelSerializer.new(x, user) }
  end
end
