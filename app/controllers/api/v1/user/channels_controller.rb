class Api::V1::User::ChannelsController < Api::V1::User::BaseController
  def index
    @channels = Channel.publics

    if @channels.present?
      render json: { success: true, data: @channels.map {|x| ChannelSerializer.new(x)} }
    else
      render json: { success: true, data: [] }
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

  private

  def create_params
    params.require(:channel).permit(:twilio_channel_sid, :friendly_name, user_ids: [])
  end
end
