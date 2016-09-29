require 'factory_girl_rails'
require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html


users = FactoryGirl.create_list :user, 10

channels = FactoryGirl.create_list :channel, 10

channels.each do |c|
  c.channel_users.create user_id: users.sample
end

friendships = []
users.each do |u|
  10.times do
    f = FactoryGirl.build(:friendship, from_user: u, to_user: users.sample)
    friendships << f if f.save
  end
end

Rake::Task['data:places'].invoke
