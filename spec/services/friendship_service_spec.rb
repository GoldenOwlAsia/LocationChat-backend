require 'rails_helper'

RSpec.describe FriendshipService do
  let(:user) { create :user }
  let(:another_user) { create :user }
  it "is valid" do
    service = FriendshipService.new(user.id, another_user.id)
    expect(service.valid?).to eq true
  end

  it "creates friendship" do
    service = FriendshipService.new(user.id, another_user.id)
    service.call
    expect(user.reload.friends).to eq [another_user]
    expect(another_user.reload.friends).to eq [user]
  end

  it "creates 2 record in friendship" do
    expect {
      FriendshipService.new(user.id, another_user.id).call
    }.to change{Friendship.count}.by 2
  end
end