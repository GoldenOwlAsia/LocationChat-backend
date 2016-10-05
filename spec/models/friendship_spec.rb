# == Schema Information
#
# Table name: friendships
#
#  id           :integer          not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  invited_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  
  describe 'in_friendship' do
    let(:user) { create :user }
    let(:another_user) { create :user }
    let!(:friendship) { FriendshipService.new(user.id, another_user.id).call }

    it "returns frienship result from user 1 to user 2" do
      frienships = Friendship.in_friendship(user.id, another_user.id)
      expect(frienships.count).to eq 2
    end

    it "returns frienship result from user 2 to user 1" do
      frienships = Friendship.in_friendship(another_user.id, user.id)
      expect(frienships.count).to eq 2
    end
  end
end
