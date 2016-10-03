# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::User::Channels::MembersController, type: :controller do

  context 'when logged in' do

    let(:user) { create(:user) }

    before { sign_in(user) }

    describe 'GET #index' do
    end
  end
end