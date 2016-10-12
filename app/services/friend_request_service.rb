class FriendRequestService < BaseService
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true

  attr_accessor :from_user_id, :to_user_id

  def initialize(from_user_id, to_user_id)
    @from_user_id = from_user_id
    @to_user_id = to_user_id
  end

  def send_request
    if valid?
      service = FriendRequest.create! from_user_id: @from_user_id, to_user_id: @to_user_id, status: FriendRequest.statuses[:pending]
      return service
    else
      return false
    end
  rescue StandardError => e
    errors.add :base, e.message
    return false
  end

  def accept_request
    if valid?
      FriendRequest.in_friendship(@from_user_id, @to_user_id).update_all(status: FriendRequest.statuses[:accepted])
      Friendship.create! from_user_id: @from_user_id, to_user_id: @to_user_id, invited_at: DateTime.now
      Friendship.create! from_user_id: @to_user_id, to_user_id: @from_user_id, invited_at: DateTime.now
      return true
    else
      return false
    end
  rescue StandardError => e
    errors.add :base, e.message
    return false
  end

  def reject_request
    if valid?
      FriendRequest.in_friendship(@from_user_id, @to_user_id).destroy_all
      Friendship.in_friendship(@from_user_id, @to_user_id).destroy_all
      return true
    else
      return false
    end
  rescue StandardError => e
    errors.add :base, e.message
    return false
  end
end
