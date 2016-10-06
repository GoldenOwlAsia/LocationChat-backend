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
        place = create :place
        result = Place.within_radius(place.latitude, place.longitude).to_a
        expect(result).to eq [place]
      end
    end
  end
end
