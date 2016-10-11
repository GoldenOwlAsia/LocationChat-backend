# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  auth_token             :string
#  uid                    :string
#  device_token           :string
#  first_name             :string
#  last_name              :string
#  number_phone           :string
#  url_image_picture      :string
#  phone_country_code     :string
#  home_city              :string
#  provider               :string
#  location               :string
#  latitude               :float
#  longitude              :float
#

require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }
  it { expect(user.valid?).to eq true }
  it { expect(user.name).to eq "#{user.first_name} #{user.last_name}"}
  describe 'initial create' do
    it 'should have setting' do
      user.save
      expect(user.reload.setting).to_not be_nil
    end
  end
end
