# == Schema Information
#
# Table name: friend_requests
#
#  id           :integer          not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  status       :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class FriendRequest < ActiveRecord::Base
  include Publish

  enum status: [:pending, :accepted, :declined]
end
