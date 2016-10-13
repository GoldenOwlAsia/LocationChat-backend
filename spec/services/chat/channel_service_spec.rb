require 'rails_helper'

RSpec.describe Chat::ChannelService do
  let(:user1) { create :user }
  let(:user2) { create :user}

  describe "filter channels" do
    context 'with valid params' do
      it "returns direct channel" do
        service = Chat::ChannelService.new [user1.id, user2.id], { friendly_name: 'Nope' }
        channel = service.call
        expect(channel.persisted?).to eq true
      end
      
      it "creates channel users" do
        service = Chat::ChannelService.new [user1.id, user2.id], { friendly_name: 'Nope' }
        channel = service.call
        expect(channel.users.count).to eq 2
      end
    end

    context 'with invalid params' do
      # TODO complete this
    end
  end
end
