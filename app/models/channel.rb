# == Schema Information
#
# Table name: channels
#
#  id                 :integer          not null, primary key
#  twilio_channel_sid :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Channel < ActiveRecord::Base
  has_many :channel_users
  has_many :users, through: :channel_users
end
