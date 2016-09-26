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
        context 'owned channel' do
          let!(:channel) { create :channel, twilio_channel_sid: '12345' }
          let!(:channel_user) { create :channel_user, user: user, channel: channel }
          before { get :index, auth_token: user.auth_token }

          it { expect_status 200 }
          it { expect_json({success: true}) }
          it { expect_json('data.0', {twilio_channel_sid: '12345'}) }
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
    end

    # describe 'GET #show' do

    #   before { get :show, id: id, auth_token: user.auth_token, format: :json }

    #   context 'with valid id' do

    #     let(:id) { user.id }

    #     it { expect(response).to have_http_status(200) }

    #   end

    #   context 'with invalid id' do

    #     let(:id) { '' }

    #     it { expect(response).to have_http_status(404) }

    #   end

    # end

    describe 'POST #create' do

      before { post :create, channel: params, auth_token: user.auth_token, format: :json }

      context 'with valid params' do
        let(:other_user) { create :user }
        let(:params) { {user_ids: [other_user.id, user.id], twilio_channel_sid: '12345', friendly_name: 'abcde' } }

        it { expect_status 201 }
        it { expect_json({success: true})}
      end

      context 'with invalid params' do
        let(:other_user) { create :user }
        let(:params) { {user_ids: [other_user.id, user.id], twilio_channel_sid: '' } }

        it { expect_status 422 }
        it { expect_json({success: false, error: "Validation failed: Twilio channel sid can't be blank, Friendly name can't be blank"})}
      end
    end
  end

end
