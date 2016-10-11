# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::User::ChannelsController, type: :controller do

  context 'when logged in' do

    let(:user) { create(:user) }

    before { sign_in(user) }

    describe 'GET #index' do

      context 'when no channel created' do
        before { get :index, auth_token: user.auth_token }

        it { expect_status 200 }
        it { expect_json({success: true, data: [] }) }
      end

      context 'when channel' do

        context 'private channel' do
          context 'owned channel' do
            let!(:channel) { create :channel, twilio_channel_sid: '12345' }
            let!(:channel_user) { create :channel_user, user: user, channel: channel }
            before { get :index, auth_token: user.auth_token }

            it { expect_status 200 }
            it { expect_json({success: true}) }
            it { expect_json('data.0', {twilio_channel_sid: '12345', users: [{ id: user.id, name: user.name, url_image_picture: user.url_image_picture }]}) }
          end

          context 'with other channels' do
            let(:channels) { create_list :channel, 5, twilio_channel_sid: 'abcde' }
            let!(:channel) { create :channel, twilio_channel_sid: '12345' }
            let!(:channel_user) { create :channel_user, user: user, channel: channel }
            before { get :index, auth_token: user.auth_token }

            it { expect_status 200 }
            it { expect_json({success: true}) }
            it { expect_json('data.0', {twilio_channel_sid: '12345'}) }
          end
        end

        context 'public channel' do
          context 'owned channel' do
            let(:place) { create :place }
            let!(:channel) { create :channel, twilio_channel_sid: '12345', public: true, place: place.reload }
            let!(:channel_user) { create :channel_user, user: user, channel: channel }
            before { get :index, auth_token: user.auth_token }

            it { expect_status 200 }
            it { expect_json({success: true}) }
            it { expect_json('data.0', {twilio_channel_sid: '12345'}) }
            it { expect_json('data.0', {place: { id: place.id, name: place.name, longitude: place.longitude, latitude: place.latitude }}) }
          end
        end

        context 'with favorite' do
          context 'when channel is favorite' do
            let(:place) { create :place }
            let!(:channel) { create :channel, twilio_channel_sid: '12345', public: true, place: place.reload }
            let!(:channel_user) { create :channel_user,is_favorite: true, user: user, channel: channel }
            before { get :index, auth_token: user.auth_token }
            it { expect_json('data.0', {twilio_channel_sid: '12345', is_favorite: true, place: { id: place.id, name: place.name, longitude: place.longitude, latitude: place.latitude }}) }
          end

          context 'when channel is not favorite' do
            let(:place) { create :place }
            let!(:channel) { create :channel, twilio_channel_sid: '12345', public: true, place: place.reload }
            let!(:channel_user) { create :channel_user,is_favorite: false, user: user, channel: channel }
            before { get :index, auth_token: user.auth_token }
            it { expect_json('data.0', {twilio_channel_sid: '12345', is_favorite: false, place: { id: place.id, name: place.name, longitude: place.longitude, latitude: place.latitude }}) }
          end
        end
      end
    end

    describe 'GET #show' do
      let(:place) { create :place }
      let!(:channel) { create :channel, twilio_channel_sid: '12345', place: place.reload  }
      before { get :show, id: channel.id, auth_token: user.auth_token, format: :json }

      context 'with valid id' do

        it { expect(response).to have_http_status(200) }
        it { expect_json({success: true, data: {id: channel.id, twilio_channel_sid: '12345', is_favorite: false, place: { id: place.id, name: place.name, longitude: place.longitude, latitude: place.latitude }}}) }
      end
    end

    describe 'GET #check_favorite' do
      let(:place) { create :place }
      let!(:channel) { create :channel, twilio_channel_sid: '12345', public: true, place: place.reload }
      let!(:channel_user) { create :channel_user,is_favorite: false, user: user, channel: channel }
      before { get :check_favorite, id: channel.id, auth_token: user.auth_token }
      it { expect_json({success: true})}
      it { expect(channel_user.reload.is_favorite).to eq true}
    end

    describe 'GET #uncheck_favorite' do
      let(:place) { create :place }
      let!(:channel) { create :channel, twilio_channel_sid: '12345', public: true, place: place.reload }
      let!(:channel_user) { create :channel_user,is_favorite: true, user: user, channel: channel }
      before { get :uncheck_favorite, id: channel.id, auth_token: user.auth_token }
      it { expect_json({success: true})}
      it { expect(channel_user.reload.is_favorite).to eq false}
    end

    describe 'DELETE #destroy' do

      context 'with valid params' do
        let!(:channel) { FactoryGirl.create(:channel) }

        it "execute successful" do
          delete :destroy, id: channel.id, auth_token: user.auth_token, format: :json
          expect_status(200)
          expect_json({success: true})
        end

        it "decreases channel count" do
          expect {
            delete :destroy, id: channel.id, auth_token: user.auth_token, format: :json
          }.to change{Channel.count}.by -1
        end
      end
    end

    describe 'POST #create' do

      before { post :create, channel: params, auth_token: user.auth_token, format: :json }

      context 'with valid params' do
        let(:other_user) { create :user }
        let(:params) { {user_ids: [other_user.id, user.id], twilio_channel_sid: '12345', friendly_name: 'abcde' } }

        it { expect_status 201 }
        it { expect_json({success: true, data: {twilio_channel_sid: '12345', friendly_name: 'abcde' }}) }
      end
    end

    describe 'PUT #update' do
      let(:channel) { create :channel }
      before { put :update, id: channel.id, channel: params, auth_token: user.auth_token, format: :json }

      context 'with valid params' do
        let(:other_user) { create :user }
        let(:params) { {user_ids: [other_user.id, user.id], twilio_channel_sid: '12345', friendly_name: 'abcde' } }

        it { expect_status 200 }
        it { expect_json({success: true, data: {id: channel.id, twilio_channel_sid: '12345', friendly_name: 'abcde' }}) }
      end
    end
  end

end
