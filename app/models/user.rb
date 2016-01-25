class User < ApplicationRecord
  has_many :events
  has_many :identities
  has_many :meetings, through: :events

  store_accessor :preferences, :frequency, :remind, :send_text
  store_accessor :meta, :slack_token, :slack_uid, :google_token

  before_create { self.frequency = 'daily'; self.remind = true; self.send_text = true }
  after_update_commit { FetchEventsJob.perform_later(id) }

  devise :database_authenticatable, :registerable,
  :omniauthable, :omniauth_providers => [:google, :slack]

  mount_uploader :avatar, AvatarUploader
  include Authenticable
  include ActionView::Helpers

  public

  def phone_verified?
    phone.present? and phone_verified
  end

  def can_text?
    phone_verified? and send_text
  end

  def from_time
    time_from_frequency.from_now.iso8601
  end

  def generate_pin
    self.pin = rand(0000..9999).to_s.rjust(4, "0")
    save
  end

  def phone_verify(entered_pin)
    update(phone_verified: true) if self.pin == entered_pin
  end

  def has_meetings?(time)
    unscoped.meetings.where("starts_at >= ?", time).count > 0
  end

  def today_meetings
    meetings.where("starts_at >= ?", office_open_time).where("starts_at <= ?", office_close_time)
  end

  def upcoming_meetings?
    upcoming_meetings.count > 0
  end

  def upcoming_meetings
    meetings.where("starts_at >= ?", Time.now.iso8601).where("starts_at <= ?", 30.minutes.from_now.iso8601)
  end

  def office_open_time
    Time.now.change(hour: 9).iso8601
  end

  def office_close_time
    Time.now.change(hour: 17).iso8601
  end

  def office_closed?
    Time.now.iso8601 > office_close_time
  end

  def frequencies
    ['daily', 'weekly', 'monthly', 'yearly']
  end

  private

  def time_from_frequency
    case frequency
    when 'daily'
      24.hours
    when 'weekly'
      7.days
    when 'monthly'
      30.days
    when 'yearly'
      365.days
    end
  end
end
