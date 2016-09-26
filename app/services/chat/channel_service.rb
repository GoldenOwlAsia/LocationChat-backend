module Chat

  class ChannelService < BaseService
    validates :user_ids, presence: true
    validates :twilio_channel_sid, presence: true

    attr_reader :user_ids, :twilio_channel_sid

    def initialize(user_ids, twilio_channel_sid)
      @user_ids = user_ids
      @twilio_channel_sid = twilio_channel_sid
    end

    def call
      if valid?
        users = User.where(id: @user_ids).map(&:id)
        ActiveRecord::Base.transaction do
          channel = Channel.new twilio_channel_sid: @twilio_channel_sid
          users.each do |id|
            channel.channel_users << ChannelUser.new(user_id: id)
          end
          channel.save!
        end
        return true
      else
        return false
      end
    rescue StandardError => e
      errors.add :base, e.message
      return false
    end
  end
end
