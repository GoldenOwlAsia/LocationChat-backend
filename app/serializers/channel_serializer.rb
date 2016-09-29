class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :twilio_channel_sid
  has_one :place
end
