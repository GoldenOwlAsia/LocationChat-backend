# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::User::SettingsController, type: :controller do

  context 'when logged in' do

    let(:user) { create(:user) }

    before { sign_in(user) }

    describe 'GET #show' do

      before { get :show, id: id, auth_token: user.auth_token, format: :json }

      context 'with valid id' do

        let(:id) { user.id }

        it { expect(response).to have_http_status(200) }
        it { expect_json success: true }
        it { expect_json({success: true, data: { friend_joins_chat: true,
                            notify_message_recieved: true,
                            notify_add_request: true } })}
      end

    end

    describe 'PUT #update' do
      before { put :update, id: user.id, setting: params, auth_token: user.auth_token }
      context 'with valid params' do
        let(:params) { { friend_joins_chat: false, notify_message_recieved: true, notify_add_request: true} }

        it { expect_status 200 }
        it { expect_json success: true }
        it { expect_json({success: true, data: { friend_joins_chat: false,
                            notify_message_recieved: true,
                            notify_add_request: true } })}
      end

    end
  end

end