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
#  previous_sign_in_at    :datetime
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
  has_many :new_friends, -> { joins(:frienships).where("friendships.invited_at < users.last_sign_in_at AND friendships.invited_at > users.previous_sign_in_at") }, through: :friendships, source: :to_user
  has_many :photos, dependent: :destroy
  has_one :setting, dependent: :destroy
  has_many :friend_requests, foreign_key: 'from_user_id', dependent: :destroy

  validates :uid, uniqueness: true

  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :channel_users
  after_create :setting_save

  def new_friends
    self.friends.where("friendships.invited_at < ? AND friendships.invited_at > ?", last_sign_in_at, previous_sign_in_at)
  end

  def old_friends
    if self.new_friends.present?
      self.friends.where.not("friendships.invited_at < ? AND friendships.invited_at > ?", last_sign_in_at, previous_sign_in_at)
    else
      self.friends
    end
  end

  def friends_pending
    @friends_pending = []
    self.friend_requests.each do |pending_f|
      @friends_pending << pending_f.to_user if pending_f.status == FriendRequest.statuses.keys.first
    end
    @friends_pending
  end

  def list_photos
    ActiveRecord::Base.transaction do
      self.photos.destroy_all if self.photos.present?
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
