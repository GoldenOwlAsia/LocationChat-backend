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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :channels, through: :channel_users
  has_many :favorite_channels, -> { where('channel_users.is_favorite = ?', true) }, through: :channel_users, source: :channel
  has_many :channel_users, dependent: :destroy

  has_many :friendships, foreign_key: 'from_user_id', class_name: 'Friendship'
  has_many :friends, through: :friendships, source: :to_user
  has_many :photos, dependent: :destroy
  has_one :setting, dependent: :destroy
  has_many :friend_requests, foreign_key: 'from_user_id', dependent: :destroy

  validates :uid, uniqueness: true

  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :channel_users
  after_create :setting_save

  class << self
    def new_friends(user)
      user.friends.where("friendships.invited_at < ? and friendships.invited_at > ?", user.last_sign_in_at, user.previous_sign_in_at)
    end

    def old_friends(user)
      if User.new_friends(user).present?
        user.friends.where.not("friendships.invited_at < ? and friendships.invited_at > ?", user.last_sign_in_at, user.previous_sign_in_at)
      else
        user.friends
      end
    end

    def friends_pending(user)
      @friends_pending = []
      user.friend_requests.each do |pending_f|
        @friends_pending << pending_f.to_user if pending_f.status == FriendRequest.statuses.keys.first
      end
      @friends_pending
    end

    def list_photos(user)
      ActiveRecord::Base.transaction do
        user.photos.destroy_all if user.photos.present?
      end
    end
  end

  def password_required?
    false
  end

  def setting_save
    @setting = setting
    if @setting.nil?
      @setting = Setting.new user_id: id
      @setting.save
    end
  end

  def name
    [first_name, last_name].compact.join(' ')
  end

  def after_database_authentication
    user = self
    user.update_attributes(previous_sign_in_at: user.last_sign_in_at)
  end
end
