class Api::V1::User::Channels::BaseController < Api::V1::User::BaseController
  before_action :find_channel

  protected

  def find_channel
    @channel = Channel.find params[:channel_id]
  end
end