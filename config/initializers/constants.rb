module Constants
  CITIES = {
    'singapore' => { lat: 1.290270, lng: 103.851959 },
    'hochiminhcity' => { lat: 10.762622, lng: 106.660172 }
  }
  PLACES_RADIUS = 10000

  GOOGLE_PLACES_RANKBY = 'distance'

  GOOGLE_PLACES_TYPES = %w(airport
                          amusement_park
                          aquarium
                          art_gallery
                          bakery
                          bank
                          bar
                          beauty_salon
                          book_store
                          bowling_alley
                          bus_station
                          cafe
                          campground
                          casino
                          cemetery
                          church
                          city_hall
                          clothing_store
                          convenience_store
                          department_store
                          embassy
                          florist
                          gym
                          hair_care
                          hindu_temple
                          hospital
                          library
                          liquor_store
                          local_government_office
                          lodging
                          mosque
                          movie_theater
                          museum
                          night_club
                          park
                          parking
                          place_of_worship
                          police
                          post_office
                          restaurant
                          school
                          shopping_mall
                          spa
                          stadium
                          store
                          subway_station
                          train_station
                          transit_station
                          university
                          colloquial_area
                          establishment
                          floor
                          food
                          health
                          intersection
                          locality
                          natural_feature
                          neighborhood
                          political
                          point_of_interest
                          room
                          street_address
                          zoo)

  module ChannelTypes
    DIRECTORY = 'directory'
    DIRECT = 'direct'
    GROUPS = 'group'
    ALL = 'all'
  end
end