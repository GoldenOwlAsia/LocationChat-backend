require 'rails_helper'

RSpec.describe ChannelService do
  let(:lat) { 10 }
  let(:lng) { 100 }
  let(:user) { create :user, latitude: lat, longitude: lng }

  describe "filter channels" do
    let!(:channel1) { create :channel, :direct, user: user }
    let!(:channel2) { create :channel, :directory, user: user }
    let!(:channel3) { create :channel, :direct, user: user }
    it "returns direct channel" do
      service = ChannelService.new user, Constants::ChannelTypes::DIRECT
      channels = service.call
      expect(channels).to match [channel1, channel3]
    end
    
    it "return directory channels only" do
      service = ChannelService.new user, Constants::ChannelTypes::DIRECTORY
      channels = service.call
      expect(channels).to match [channel2]
    end

    it "returns all channels" do
      service = ChannelService.new user
      channels = service.call
      expect(channels).to match [channel1, channel2, channel3]
    end
  end
end