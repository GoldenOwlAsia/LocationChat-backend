# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::User::TokensController, type: :controller do

  let(:user) { create :user }

  before { sign_in user }

  describe 'POST #create' do
    context 'when params is valid' do
      it { expect_status(200) }
      it do 
        allow_any_instance_of(TwilioAuthService).to receive(:call).and_return('12345')
        post :create, auth_token: user.auth_token, format: :json
        expect_json({success: true, data: {token: '12345'} })
      end
    end
  end
end