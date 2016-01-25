class Meeting < ApplicationRecord
  has_many :events
  has_many :users, through: :events
  default_scope { where("starts_at >= ?", Time.now.utc).order(starts_at: :desc) }

  def self.meeting_attrs(event, user_id)
    {
      meeting_id: event.id,
      user_id: user_id,
      starts_at: event.start.date_time,
      ends_at: event.end.date_time,
      info: event.to_json
    }
  end
end
