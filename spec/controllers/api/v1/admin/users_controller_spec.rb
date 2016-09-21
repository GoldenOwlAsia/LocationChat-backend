# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Admin::UsersController, type: :controller do

  context 'when not logged in' do

    it { expect(get(:index)).to have_http_status(401) }
    it { expect(get(:show, id: 1)).to have_http_status(401) }
    it { expect(post(:create)).to have_http_status(401) }
    it { expect(patch(:update, id: 1)).to have_http_status(401) }

  end

  context 'when logged in' do

    let(:admin) { create(:user) }

    before { sign_in(admin) }

    describe 'GET #index' do

      before { get :index }

      it { expect(response).to have_http_status(200) }

    end

    describe 'GET #show' do

      let(:user) { create(:user) }

      before { get :show, id: id }

      context 'with valid id' do

        let(:id) { user.id }

        it { expect(response).to have_http_status(200) }

      end

      context 'with invalid id' do

        let(:id) { '' }

        it { expect(response).to have_http_status(404) }

      end

    end

    describe 'POST #create' do

      before { post :create, data: data }

      let(:data) do
        {
          type: 'users',
          attributes: attributes
        }
      end

      context 'with valid params' do

        let(:attributes) { attributes_for(:user) }

        it { expect(response).to have_http_status(201) }

      end

      context 'with invalid params' do

        let(:attributes) { attributes_for(:user, :blank_email) }

        it { expect(response).to have_http_status(422) }

      end

    end

    describe 'PATCH #update' do

      let(:user) { create(:user) }

      before { patch :update, id: id, data: data }

      let(:data) do
        {
          type: 'usres',
          attributes: attributes
        }
      end

      context 'with invalid id' do

        let(:id) { 'dne' }
        let(:attributes) { attributes_for(:user) }

        it { expect(response).to have_http_status(404) }

      end

      context 'with valid id' do

        let(:id) { user.id }

        context 'with valid params' do

          let(:attributes) { attributes_for(:user, :blank_password, :blank_password_confirmation) }

          it { expect(response).to have_http_status(200) }

        end

        context 'with invalid params' do

          let(:attributes) { attributes_for(:user, :blank_email) }

          it { expect(response).to have_http_status(422) }

        end

      end

    end

  end

end
