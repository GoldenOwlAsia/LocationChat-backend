# == Schema Information
#
# Table name: channel_users
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  channel_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_favorite :boolean          default(FALSE)
#

class ChannelUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
end
