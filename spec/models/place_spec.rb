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

require 'rails_helper'

RSpec.describe Place, type: :model do
  describe "within_radius" do
    context 'out of range' do
      it "does not return places" do
        place = create :place
        result = Place.within_radius(place.latitude + 5, place.longitude + 5)
        expect(result).to eq []
      end
    end

    context 'within range' do
      it "returns places" do
        latitude = 10
        longitude = 100
        place = create :place, latitude: latitude, longitude: longitude
        puts place.longitude
        puts place.latitude
        result = Place.within_radius(latitude + 0.0000000000001, longitude + 0.0000000000001).to_a
        expect(result).to eq [place]
      end
    end
  end
end
