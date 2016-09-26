class FriendshipService < BaseService
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true

  attr_accessor :from_user_id, :to_user_id

  def initialize(from_user_id, to_user_id)
    @from_user_id = from_user_id
    @to_user_id = to_user_id
  end

  def call
    if valid?
      from_user = User.find @from_user_id
      to_user = User.find @to_user_id
      ActiveRecord::Base.transaction do
        from_user.friendships.create! to_user: to_user
        to_user.friendships.create! to_user: from_user
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
