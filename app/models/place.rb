# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  name       :string
#  longitude  :float
#  latitude   :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  photo_url  :string
#  address    :string
#  place_id   :string
#

class Place < ActiveRecord::Base
  has_one :channel, dependent: :destroy

  validates :name, uniqueness: true

  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude


  scope :within_radius, ->(latitude, longitude) { within(Constants::PLACES_RADIUS / 1000, origin: [latitude, longitude]) }
end
