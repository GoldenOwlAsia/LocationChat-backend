# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::User::SessionsController, type: :controller do
  let!(:user) { create(:user, uid: '12345', device_token: 'qwerty', first_name: 'Vinh',
                            last_name: 'Nguyen',
                            number_phone: '0964153741',
                            email: 'nguyenhuuvinh2001@gmail.com',
                            url_image_picture: 'image.png',
                            phone_country_code: '+084',
                            home_city: 'Ho Chi Minh City') }

  describe 'POST #create' do
    before { post :create, session: params, format: :json }

    context 'with valid params' do
      let(:params) { { provider: :facebook, uid: '12345', device_token: 'qwerty' } }

      it { expect_status(200) }
      it do
        user.reload
        expect_json({
          success: true,
          data: { id: user.id, email: user.email, auth_token: user.auth_token, device_token: user.device_token }
        })
      end
    end

    context 'with invalid uid' do
      let(:params) { { provider: :facebook, uid: '123454321', device_token: 'qwerty' } }

      it { expect_status(401) }
      it { expect_json({success: false, error: 'invalid credentials'})}
    end

  end

  describe 'DELETE #destroy' do
    context 'when logged in' do
      before { delete :destroy, auth_token: user.auth_token, format: :json }

      it { expect_status(200) }
      it { expect(user.reload.auth_token).to be_nil }
    end

    context 'when not logged in' do
      before { delete :destroy, auth_token: '', format: :json }

      it { expect_status(401) }
    end
  end

end