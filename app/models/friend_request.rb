class FriendRequest < ActiveRecord::Base
  include Publish

  belongs_to :user

  enum status: [:pending, :accepted, :declined]
end