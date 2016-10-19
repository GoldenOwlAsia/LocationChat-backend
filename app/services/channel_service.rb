class ChannelService
  
  def initialize(user, type = nil)
    @user = user
    @type = type || Constants::ChannelTypes::ALL
  end

  def call
    case @type
    when Constants::ChannelTypes::DIRECTORY
      # binding.pry
      directory_channels
    when Constants::ChannelTypes::DIRECT
      direct_channels
    when Constants::ChannelTypes::GROUPS
      grouped_channels
    else
      all_channels
    end
  end

  def grouped_channels
    channels = @user.channels
    favorite_channels = @user.favorite_channels.to_a
    within_radius = channels.within_radius(@user.latitude, @user.longitude).to_a - favorite_channels
    outside_radius = channels - favorite_channels - within_radius
    { favorite: favorite_channels, within_radius: within_radius, outside_radius: outside_radius }
  end

  def directory_channels
    Channel.publics.within_radius(@user.latitude, @user.longitude)
  end

  def direct_channels
    @user.channels.privates
  end

  def all_channels
    @user.channels
  end
end
