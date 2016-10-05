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
#  public             :boolean
#

class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :twilio_channel_sid, :friendly_name, :photo_url
  attribute :favorite?, key: :is_favorite
  has_one :place
  has_many :users

  def initialize(model, user)
    super model
    @user = user
  end

  def favorite?
    obj = object.channel_users.where(user_id: @user.id).last if @user.present?

    if obj
      obj.is_favorite 
    else
      false
    end
  end

  def users
    object.users.map do |user|
      { id: user.id, name: user.name, url_image_picture: user.url_image_picture }
    end
  end

  def photo_url
    if object.public
      object.place.present? ? object.place.photo_url : nil
    else
      object.users.last.url_image_picture if object.users.present?
    end
  end
end
