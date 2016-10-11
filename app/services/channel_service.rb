class ChannelService
  
  def initialize(user, type = nil)
    @user = user
    @type = type || Constants::ChannelTypes::ALL
  end

  def call
    case @type
    when Constants::ChannelTypes::DIRECTORY
      directory_channels
    when Constants::ChannelTypes::DIRECT
      direct_channels
    else
      all_channels
    end
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
