class UpdatePlacesJob < ActiveJob::Base
  queue_as :default

  def perform(lat, lng)
    puts "Execute job: UpdatePlacesJob #{lat} #{lng}"
    PlaceLookupService.new(lat, lng).call
  end
end
