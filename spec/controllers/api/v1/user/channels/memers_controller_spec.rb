# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::User::Channels::MembersController, type: :controller do

  context 'when logged in' do

    let(:user) { create(:user) }
    let!(:channel) { create :channel, twilio_channel_sid: '12345' }

    before { sign_in(user) }

    describe 'GET #index' do
      context 'when no member' do
        before { get :index, auth_token: user.auth_token, channel_id: channel.id }

        it { expect_status 200 }
        it { expect_json({success: true, data: [] }) }
      end

      context 'when there are members' do
        let!(:channel_user) { create :channel_user, user: user, channel: channel }
        before { get :index, auth_token: user.auth_token, channel_id: channel.id }

        it { expect_status 200 }
        it { expect_json({success: true}) }
        it { expect_json('data.0', {id: user.id }) }
      end
    end

    describe 'POST #create' do
      before { post :create, auth_token: user.auth_token, channel_id: channel.id, user_id: user_id }

      context 'when add a new member' do
        let(:user_id) { create(:user).id }

        it { expect_status 200 }
        it { expect_json({success: true}) }
        it { change{ChannelUser.count}.by(1) }
      end
      context 'when add an existing member' do
        let(:other_user) { create :user }
        let!(:channel_user) { create :channel_user, user: other_user, channel: channel }
        let(:user_id) { other_user.id }
        let!(:count) { ChannelUser.count }

        it { expect_status 200 }
        it { expect_json({success: true}) }
        it { expect(ChannelUser.count).to eq count }
      end
    end

    describe 'DELETE #destroy' do
      context 'when destroy a non-existing member' do
        let(:user_id) { 100 }

        before { delete :destroy, auth_token: user.auth_token, channel_id: channel.id, user_id: user_id }

        it { expect_status 200 }
        it { expect_json({success: true}) }
      end

      context 'when destroy a member' do
        let(:other_user) { create :user }
        let!(:channel_user) { create :channel_user, user: other_user, channel: channel }
        let(:user_id) { other_user.id }
        let!(:count) { ChannelUser.count }

        it "executes successful" do
          delete :destroy, auth_token: user.auth_token, channel_id: channel.id, user_id: user_id
          expect_status 200
          expect_json({success: true})
        end

        it "removes user from channel" do 
          expect {
            delete :destroy, auth_token: user.auth_token, channel_id: channel.id, user_id: user_id
          }.to change{ChannelUser.count}.by -1
        end
      end
    end
  end
end