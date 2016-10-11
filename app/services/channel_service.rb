class ChannelService
  
  def initialize(user, type = nil)
    @user = user
    @type = type || 'all'
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
    # binding.pry
    @user.channels.where(public: false)
  end

  def all_channels
    @user.channels
  end
end
