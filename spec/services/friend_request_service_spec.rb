require 'rails_helper'

RSpec.describe FriendRequestService do
  let(:user) { create :user }
  let(:another_user) { create :user }

  subject { FriendRequestService.new(user.id, another_user.id) }
  describe 'Check subject is valid?' do
    it "is valid" do
      expect(subject.valid?).to eq true
    end
  end

  describe 'POST #send_add_friend' do
    it "creates 2 records in friend_requests" do
      expect {
        subject.send_request
      }.to change{FriendRequest.count}.by 2
    end

    it "can't create 2 records when invalid params" do
      subject.to_user_id = nil
      expect(subject.valid?).to eq false
    end
  end

  describe 'POST #accept_add_friend' do
    it "create 2 records in friendship when accept friend" do
      expect {
        subject.accept_request
      }.to change{Friendship.count}.by 2
    end

    it "can't create 2 records to friendship when invalid params" do
      subject.to_user_id = nil
      expect(subject.valid?).to eq false
    end
  end

  describe 'POST #reject_add_friend' do
    it "remove 2 record in friendship when declined friend" do
      expect {
        subject.reject_request
      }.to change{Friendship.count}.by 0
    end

    it "can't delete 2 records in friendship when invalid params" do
      subject.to_user_id = nil
      expect(subject.valid?).to eq false
    end
  end
end
