require 'rails_helper'

RSpec.describe FriendRequestService do
  let(:user) { create :user }
  let(:another_user) { create :user }
  it "is valid" do
    service = FriendRequestService.new(user.id, another_user.id)
    expect(service.valid?).to eq true
  end

  it "creates 2 records in friend_requests" do
    expect {
      FriendRequestService.new(user.id, another_user.id).send_request
    }.to change{FriendRequest.count}.by 2
  end

  it "create 2 records in friendship when accept friend" do
    expect {
      FriendRequestService.new(user.id, another_user.id).accept_request
    }.to change{Friendship.count}.by 2
  end

  it "remove 2 record in friendship when declined friend" do
    service = FriendRequestService.new(user.id, another_user.id).reject_request
    expect {
      service
    }.to change{Friendship.count}.by 0
  end
end