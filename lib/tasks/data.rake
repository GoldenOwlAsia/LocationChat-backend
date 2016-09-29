namespace :data do
  desc "Generate places based on Google API"
  task places: :environment do
    Constants::CITIES.each do |key, value|
      service = PlaceLookupService.new value[:lat], value[:lng]
      service.call
    end
  end

end
