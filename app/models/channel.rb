# == Schema Information
#
# Table name: channels
#
#  id                 :integer          not null, primary key
#  twilio_channel_sid :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  friendly_name      :string
#  place_id           :integer
#  public             :boolean          default(FALSE)
#

class Channel < ActiveRecord::Base
  has_many :channel_users
  has_many :users, through: :channel_users
  belongs_to :place

  # validates :twilio_channel_sid, presence: true
  # validates :friendly_name, presence: true

  scope :publics, -> { where(public: true)}
  scope :privates, -> { where(public: false) }
  scope :within_radius, ->(latitude, longitude) { where(place_id: Place.within_radius(latitude, longitude)) }

  def name
    place.name if place
  end

  def to_builder
    Jbuilder.new do |channel|
      channel.name name
      channel.twilio_channel_sid twilio_channel_sid
    end
  end
end
