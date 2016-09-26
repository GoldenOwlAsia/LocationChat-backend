# == Schema Information
#
# Table name: channels
#
#  id                 :integer          not null, primary key
#  twilio_channel_sid :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  friendly_name      :string
#

class Channel < ActiveRecord::Base
  has_many :channel_users
  has_many :users, through: :channel_users

  validates :twilio_channel_sid, presence: true
  validates :friendly_name, presence: true
end
