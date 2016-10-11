class FriendRequest < ActiveRecord::Base
  include Publish

  enum status: [:pending, :accepted, :declined]
end