class PlaceLookupService < BaseService
  attr_reader :lat, :lng
  def initialize(lat, lng)
    @lat = lat;
    @lng = lng;
    @client = GooglePlaces::Client.new(Rails.application.secrets.google_place_api_key)
  end

  def call
    spots = @client.spots(@lat, @lng)
    places = parse_spots spots
    
    places.each do |p|
      if p.valid?
        p.save!
        Channel.create! place: p
        puts "Place #{p.name} saved."
      end
    end
  end

  private

  def parse_spots(spots)
    spots.map do |spot|
      Place.new name: spot.name, longitude: spot.lng, latitude: spot.lat
    end
  end
end