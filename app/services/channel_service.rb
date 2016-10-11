class ChannelService
  
  def initialize(user, type)
    @user = user
    @type = type
  end

  def call
    case @type
    when 'directory'
      directory_channels
    when 'direct'
      direct_channels
    else
      all_channels
    end
  end

  def directory_channels
    Channel.publics.within_radius(@user.latitude, @user.longitude)
  end

  def direct_channels
     @user.channels.where(place: nil)
  end

  def all_channels
    direct_channels + directory_channels
  end
end
