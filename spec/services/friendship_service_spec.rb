require 'rails_helper'

RSpec.describe FriendshipService do
  let(:user) { create :user }
  let(:another_user) { create :user }
  it "is valid" do
    service = FriendshipService.new(user.id, another_user.id)
    expect(service.valid?).to eq true
  end
end