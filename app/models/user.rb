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
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :channels, through: :channel_users
  has_many :channel_users, dependent: :destroy

  validates :uid, uniqueness: true

  def password_required?
    false
  end

end
