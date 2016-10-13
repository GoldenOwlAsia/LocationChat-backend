module Chat
  class ChannelService < BaseService
    validates :user_ids, presence: true
    validates :params, presence: true

    attr_reader :user_ids, :params

    def initialize(user_ids, params)
      @user_ids = user_ids
      @params = params
    end

    def call
      if valid?
        users = User.where(id: @user_ids).map(&:id)
        channel = Channel.new @params
        ActiveRecord::Base.transaction do
          channel_users = []
          users.each do |id|
            channel_users << ChannelUser.new(user_id: id)
          end
          channel.channel_users = channel_users
          channel.save!
        end
        return channel
      else
        return false
      end
    rescue StandardError => e
      errors.add :base, e.message
      return false
    end
  end
end
