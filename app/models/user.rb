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
#  latitude               :string
#  longitude              :string
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :channels, through: :channel_users
  has_many :channel_users, dependent: :destroy

  has_many :friendships, foreign_key: 'from_user_id', class_name: 'Friendship'
  has_many :friends, through: :friendships, source: :to_user
  has_many :photos, dependent: :destroy
  has_one :setting, dependent: :destroy

  validates :uid, uniqueness: true

  accepts_nested_attributes_for :photos
  after_create :setting_save
  def password_required?
    false
  end

  def setting_save
    @setting = self.setting
    if @setting.nil?
      @setting = Setting.new user_id: self.id
      @setting.save
    end
  end

end
