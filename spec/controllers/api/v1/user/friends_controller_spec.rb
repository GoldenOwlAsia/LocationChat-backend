# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::User::FriendsController, type: :controller do

  context 'when logged in' do

    let(:user) { create(:user) }

    before { sign_in(user) }

    describe 'GET #index' do

      context 'when no friend created' do
        before { get :index, auth_token: user.auth_token }

        it { expect_status 200 }
        it { expect_json({success: true, data: [] }) }
      end

      context 'when friend' do
        context 'owned friend' do
          let!(:another_user) { create :user }
          let!(:friendship) { create :friendship, from_user: user, to_user: another_user }

          before { get :index, auth_token: user.auth_token }

          it { expect_status 200 }
          it { expect_json({success: true}) }
          it { expect_json('data.0', {email: another_user.email}) }
        end
      end
    end

    describe 'POST #create' do
      context 'with no existing friendship' do
        let!(:another_user) { create :user }

        before { post :create, auth_token: user.auth_token, friendship: { to_user_id: another_user.id } }

        it { expect_status 201 }
        it { expect_json({success: true}) }
      end

      context 'with existing friendship' do
        let!(:another_user) { create :user }
        let!(:friendship) { create :friendship, from_user: user, to_user: another_user }

        before { post :create, auth_token: user.auth_token, friendship: params }

        context 'with params' do
          let(:params) { { to_user_id: another_user.id } }
          it { expect_status 422 }
          it { expect_json({success: false, error: "Validation failed: To user already existed"}) }
        end
      end
    end
  end
end