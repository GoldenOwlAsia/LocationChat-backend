# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::User::ProfilesController, type: :controller do

  context 'when not logged in' do

    it { expect(get(:index)).to have_http_status(401) }
    it { expect(get(:show, id: 1)).to have_http_status(401) }
    # it { expect(post(:create)).to have_http_status(401) }
    # it { expect(patch(:update, id: 1)).to have_http_status(401) }

    describe 'GET #check' do
      before { get :check, profile: params }

      context 'with valid params' do
        let!(:user) { create :user }
        let(:params) { {provider: :facebook, uid: user.uid, device_token: user.device_token} }

        it { expect_status 200 }
        it { expect_json success: true }
      end

      context 'with invalid params' do
        let(:params) { {provider: :facebook, uid: '32323', device_token: 'fs f df'} }

        it { expect_status 200 }
        it { expect_json success: false }
      end
    end
  end

  context 'when logged in' do

    let(:user) { create(:user) }

    before { sign_in(user) }

    # describe 'GET #index' do

    #   before { get :index }

    #   it { expect_status 200 }

    # end

    describe 'GET #show' do

      before { get :show, id: id, auth_token: user.auth_token, format: :json }

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

      before { post :create, profile: params }

      context 'with valid params' do

        let(:params) { {email: 'test@example.com', uid: '12345', device_token: 'abcde',
                                    first_name: 'Vinh',
                                    last_name: 'Nguyen',
                                    number_phone: '0964153741',
                                    url_image_picture: 'image.png', 
                                    phone_country_code: '+084', 
                                    home_city: 'Ho Chi Minh City'} }

        it { expect_status 201 }
        it { expect_json({success: true, data: { email: 'test@example.com', auth_token: User.last.auth_token, device_token: 'abcde',
                            first_name: 'Vinh',
                            last_name: 'Nguyen',
                            number_phone: '0964153741',
                            url_image_picture: 'image.png', 
                            phone_country_code: '+084', 
                            home_city: 'Ho Chi Minh City' } })}

      end

      context 'with invalid params' do

        context 'blank email' do
          let(:params) { {email: '', uid: '12345', device_token: user.device_token,
                                      first_name: 'Vinh',
                                      last_name: 'Nguyen',
                                      number_phone: '0964153741',
                                      url_image_picture: 'image.png', 
                                      phone_country_code: '+084', 
                                      home_city: 'Ho Chi Minh City'} }

          it { expect_status 422 }
          it { expect_json success: false, error: "Email can't be blank" }
        end

        context 'duplicated facebook id' do
          let!(:another_user) { create :user }

          let(:params) { {email: 'test@example.com', uid: another_user.uid, device_token: user.device_token,
                                      first_name: 'Vinh',
                                      last_name: 'Nguyen',
                                      number_phone: '0964153741',
                                      url_image_picture: 'image.png', 
                                      phone_country_code: '+084', 
                                      home_city: 'Ho Chi Minh City'} }

          it { expect_status 422 }
          it { expect_json success: false, error: 'Uid has already been taken' }
        end

      end

    end

    # describe 'PATCH #update' do

    #   let(:user) { create(:user) }

    #   before { patch :update, id: id, data: data }

    #   let(:data) do
    #     {
    #       type: 'usres',
    #       attributes: attributes
    #     }
    #   end

    #   context 'with invalid id' do

    #     let(:id) { 'dne' }
    #     let(:attributes) { attributes_for(:user) }

    #     it { expect(response).to have_http_status(404) }

    #   end

    #   context 'with valid id' do

    #     let(:id) { user.id }

    #     context 'with valid params' do

    #       let(:attributes) { attributes_for(:user, :blank_password, :blank_password_confirmation) }

    #       it { expect(response).to have_http_status(200) }

    #     end

    #     context 'with invalid params' do

    #       let(:attributes) { attributes_for(:user, :blank_email) }

    #       it { expect(response).to have_http_status(422) }

    #     end

    #   end

    # end

  end

end