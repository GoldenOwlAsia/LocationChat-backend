# frozen_string_literal: true
class Api::V1::ChannelSerializer < Api::V1::BaseSerializer

  attributes :id,
             :twilio_channel_sid

end
