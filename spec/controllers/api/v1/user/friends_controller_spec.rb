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
        it { expect_json({ success: true, data: { old_friends: [], new_friends: [], pending_friend: [] } }) }
      end

      context 'when friend' do
        context 'owned friend' do
          let!(:another_user) { create :user }
          let!(:friendship) { create :friendship, from_user: user, to_user: another_user }

          before { get :index, auth_token: user.auth_token }

          it { expect_status 200 }
          it { expect_json({ success: true }) }
        end

        context 'pagination' do
          before do
            users = create_list :user, 20
            users.each do |u|
              create :friendship, from_user: user, to_user: u
            end
          end

          it "return correct total" do
            get :index, auth_token: user.auth_token, page: 0
            expect_json(total: 20)
          end
        end
      end
    end

    describe 'POST #send_request_add_friend' do
      context 'with no existing friendship' do
        let!(:another_user) { create :user }
        before { post :send_add_friend, auth_token: user.auth_token, friendship: { to_user_id: another_user.id } }
        it { expect_status 201 }
        it { expect_json({ success: true }) }
      end

      context 'with existing friendship' do
        let!(:another_user) { create :user }
        let!(:friendship) { create :friendship, from_user: user, to_user: another_user }
        before { post :accept_add_friend, auth_token: user.auth_token, friendship: params }
        context 'with params' do
          let(:params) { { to_user_id: another_user.id } }
          it { expect_status 422 }
          it { expect_json({ success: false, error: "Validation failed: To user already existed" }) }
        end
      end
    end

    describe 'POST #accept_add_friend' do
      context 'with no existing friendship' do
        let!(:another_user) { create :user }
        before { post :accept_add_friend, auth_token: user.auth_token, friendship: { to_user_id: another_user.id } }
        it { expect_status 201 }
        it { expect_json({ success: true }) }
      end

      context 'with existing friendship' do
        let!(:another_user) { create :user }
        let!(:friendship) { create :friendship, from_user: user, to_user: another_user }
        before { post :accept_add_friend, auth_token: user.auth_token, friendship: params }
        context 'with params' do
          let(:params) { { to_user_id: another_user.id } }
          it { expect_status 422 }
          it { expect_json({ success: false, error: "Validation failed: To user already existed" }) }
        end
      end
    end

    describe 'POST #reject_add_friend' do
      context 'reject when have request add friend' do
        let!(:another_user) { create :user }
        before { post :reject_add_friend, auth_token: user.auth_token, friendship: { to_user_id: another_user.id } }
        it { expect_status 201 }
        it { expect_json({ success: true }) }
      end
    end
  end
end
