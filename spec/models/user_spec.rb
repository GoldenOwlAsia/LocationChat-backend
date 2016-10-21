# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  auth_token             :string
#  uid                    :string
#  device_token           :string
#  first_name             :string
#  last_name              :string
#  number_phone           :string
#  url_image_picture      :string
#  phone_country_code     :string
#  home_city              :string
#  provider               :string
#  location               :string
#  latitude               :float
#  longitude              :float
#  previous_sign_in_at    :datetime
#

require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }

  it { expect(user.valid?).to eq true }
  it { expect(user.name).to eq "#{user.first_name} #{user.last_name}"}
  describe 'Initial create' do
    it 'should have setting' do
      user.save
      expect(user.reload.setting).to_not be_nil
    end
  end

  describe "new friends" do
    it "returns new friends" do
      user2 = create :user
      invited_at = DateTime.now - 3.days
      Friendship.create! from_user_id: user.id, to_user_id: user2.id, invited_at: invited_at
      Friendship.create! from_user_id: user2.id, to_user_id: user.id, invited_at: invited_at
      allow_any_instance_of(User).to receive(:last_sign_in_at).and_return(DateTime.now)
      allow_any_instance_of(User).to receive(:previous_sign_in_at).and_return(DateTime.now - 1.week)
      result = user.new_friends
      expect(result).to eq [user2]
    end

    it "does not return new friends when friendship was older than previous_sign_in_at" do
      user2 = create :user
      previous_sign_in_at = 2.weeks.ago
      invited_at = 3.weeks.ago
      Friendship.create! from_user_id: user.id, to_user_id: user2.id, invited_at: invited_at
      Friendship.create! from_user_id: user2.id, to_user_id: user.id, invited_at: invited_at
      allow_any_instance_of(User).to receive(:last_sign_in_at).and_return(DateTime.now)
      allow_any_instance_of(User).to receive(:previous_sign_in_at).and_return(previous_sign_in_at)
      result = user.new_friends
      expect(result).to eq []
    end

    it "does not return new friends when friendship was older than previous_sign_in_at" do
      user2 = create :user
      previous_sign_in_at = 2.weeks.ago
      last_sign_in_at = 2.days.ago
      invited_at = DateTime.yesterday
      Friendship.create! from_user_id: user.id, to_user_id: user2.id, invited_at: invited_at
      Friendship.create! from_user_id: user2.id, to_user_id: user.id, invited_at: invited_at
      allow_any_instance_of(User).to receive(:last_sign_in_at).and_return(last_sign_in_at)
      allow_any_instance_of(User).to receive(:previous_sign_in_at).and_return(previous_sign_in_at)
      result = user.new_friends
      expect(result).to eq []
    end
  end

  describe "old friends" do
    it "returns old friends" do
      user2 = create :user
      invited_at = DateTime.now - 3.days
      Friendship.create! from_user_id: user.id, to_user_id: user2.id, invited_at: invited_at
      Friendship.create! from_user_id: user2.id, to_user_id: user.id, invited_at: invited_at
      allow_any_instance_of(User).to receive(:last_sign_in_at).and_return(DateTime.now)
      allow_any_instance_of(User).to receive(:previous_sign_in_at).and_return(DateTime.now - 1.day)
      result = user.old_friends
      expect(result).to eq [user2]
    end

    it "does not return old friends when invited was older than previous_sign_in_at" do
      user2 = create :user
      previous_sign_in_at = 2.weeks.ago
      invited_at = 1.weeks.ago
      Friendship.create! from_user_id: user.id, to_user_id: user2.id, invited_at: invited_at
      Friendship.create! from_user_id: user2.id, to_user_id: user.id, invited_at: invited_at
      allow_any_instance_of(User).to receive(:last_sign_in_at).and_return(DateTime.now)
      allow_any_instance_of(User).to receive(:previous_sign_in_at).and_return(previous_sign_in_at)
      result = user.old_friends
      expect(result).to eq []
    end
  end

  describe "pending friends" do
    it "returns pending friends" do
      user2 = create :user
      FriendRequest.create! from_user_id: user.id, to_user_id: user2.id, status: FriendRequest.statuses[:pending]
      FriendRequest.create! from_user_id: user2.id, to_user_id: user.id, status: FriendRequest.statuses[:pending]
      result = user.friends_pending
      expect(result).to eq [user2]
    end
  end

  context "Associations" do
    it { should have_many(:channel_users) }
    it { should have_many(:channels).through(:channel_users) }
    it { should have_many(:friendships).class_name('Friendship') }
    it { should have_many(:friends).through(:friendships) }
    it { should have_many(:photos) }
    it { should have_one(:setting) }
    it { should have_many(:friend_requests) }
  end
end
