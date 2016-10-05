# == Schema Information
#
# Table name: channels
#
#  id                 :integer          not null, primary key
#  twilio_channel_sid :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  friendly_name      :string
#  place_id           :integer
#  public             :boolean
#

require 'rails_helper'

RSpec.describe Channel, type: :model do
  describe 'deletion' do
    context 'should delete channel users' do
      let(:user) { create :user }
      let(:channel) { create :channel }
      let!(:channel_user) { channel.channel_users.create user_id: user.id }
      before { channel.destroy }
      it { change{ChannelUser.count}.by -1 }
    end
  end
end
