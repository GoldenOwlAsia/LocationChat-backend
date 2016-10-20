require 'factory_girl_rails'
require 'faker'
I18n.reload!

namespace :data do
  desc "Generate places based on Google API"
  task places: :environment do
    Constants::CITIES.each do |key, value|
      service = PlaceLookupService.new value[:lat], value[:lng]
      service.call
    end
  end

  desc "Generate fake users"
  task users: :environment do
    users = FactoryGirl.create_list :user, 10

    users.each do |user|
      5.times do
        FactoryGirl.create(:photo, user: user)
      end
      c = FactoryGirl.create :channel
      FactoryGirl.create :channel_user, user: user, channel: c
      FactoryGirl.create :channel_user, user: users.select { |x| x.id != user.id }.sample, channel: c
    end

    friendships = []
    users.each do |u|
      10.times do
        f = FactoryGirl.build(:friendship, from_user: u, to_user: users.sample)
        friendships << f if f.save
      end
    end

    public_channels = Channel.where(public: true).to_a
    public_channels.each do |c|
      users.each do |u|
        c.channel_users.create user: u
      end
    end
  end
end
