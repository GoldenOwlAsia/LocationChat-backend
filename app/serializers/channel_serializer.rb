# frozen_string_literal: true
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
#

class ChannelSerializer < BaseSerializer
  attributes :id,
             :twilio_channel_sid
end
