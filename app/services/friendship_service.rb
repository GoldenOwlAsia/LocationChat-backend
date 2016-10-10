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
      Friendship.create! from_user_id: @from_user_id, to_user_id: @to_user_id
      Friendship.create! from_user_id: @to_user_id, to_user_id: @from_user_id
      return true
    else
      return false
    end
  rescue StandardError => e
    errors.add :base, e.message
    return false
  end

  def send_request
    if valid?
      Friendship.create! from_user_id: @from_user_id, to_user_id: @to_user_id, invited_at: DateTime.now, status: Friendship.statuses[:pending]
      Friendship.create! from_user_id: @to_user_id, to_user_id: @from_user_id, invited_at: DateTime.now, status: Friendship.statuses[:pending]
      return true
    else
      return false
    end
  rescue StandardError => e
    errors.add :base, e.message
    return false
  end

  def accept_request
    if valid?
      Friendship.in_friendship(@from_user_id, @to_user_id).update_all(status: Friendship.statuses[:accepted])
      return true
    else
      return false
    end
  rescue StandardError => e
    errors.add :base, e.message
    return false
  end
end
