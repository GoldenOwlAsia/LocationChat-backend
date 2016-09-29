class ChannelLookupService < BaseService
  attr_reader :user
  def initialize(user)
    @user = user
    @client = GooglePlaces::Client.new(Rails.application.secrets.google_place_api_key)
  end

  def call
    spots = @client.spots(-33.8670522, 151.1957362)
    binding.pry
  end
end