# == Schema Information
#
# Table name: channels
#
#  id                 :integer          not null, primary key
#  twilio_channel_sid :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  friendly_name      :string
#  place_id           :integer
#  public             :boolean
#

class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :twilio_channel_sid
  has_one :place
end
