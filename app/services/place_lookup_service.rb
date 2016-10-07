class PlaceLookupService < BaseService
  attr_reader :lat, :lng
  def initialize(lat, lng)
    @lat = lat;
    @lng = lng;
    @client = GooglePlaces::Client.new(Rails.application.secrets.google_place_api_key)
  end

  def call
    spots = @client.spots(@lat, @lng, radius: Constants::PLACES_RADIUS)
    places = parse_spots spots
    
    places.each do |p|
      puts p.inspect
      if p.valid?
        p.save!
        Channel.create! place: p, public: true
        puts "Place #{p.name} saved."
      end
    end
  end

  def client
    @client
  end

  private

  def parse_spots(spots)
    spots.map do |spot|
      puts spot.inspect
      # puts "Spot vicinity #{spot.vicinity}"
      photo_url = spot.photos.present? ? spot.photos[0].fetch_url(100) : spot.icon
      Place.new name: spot.name, longitude: spot.lng, latitude: spot.lat, photo_url: photo_url, address: spot.vicinity
    end
  end
end