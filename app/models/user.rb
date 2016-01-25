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

  def calendar_events
    calendar = Google::Apis::CalendarV3::CalendarService.new
    events = calendar.list_events(
      'primary',
      always_include_email: true,
      single_events: false,
      order_by: 'updated',
      time_min: Time.now.iso8601,
      time_max: from_time,
      options: {
        authorization: google_token
      }
    )
  end

  def phone_verified?
    phone.present? and phone_verified
  end

  def can_text?
    phone_verified? and send_text
  end

  def from_time
    time_from_frequency.from_now.iso8601
  end

  def frequencies
    ['daily', 'weekly', 'monthly', 'yearly']
  end

  def generate_pin
    self.pin = rand(0000..9999).to_s.rjust(4, "0")
    save
  end

  def phone_verify(entered_pin)
    update(phone_verified: true) if self.pin == entered_pin
  end

  def send_pin
    twilio_client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    twilio_client.messages.create(
      to: phone,
      from: ENV['TWILIO_PHONE_NUMBER'],
      body: "Your Meeting PIN is #{pin}. Please enter into your app to verify your number"
    )
  end

  def has_meetings?(time)
    unscoped.meetings.where("starts_at >= ?", time).count > 0
  end

  def today_meetings
    meetings.where("starts_at >= ?", office_open_time).where("starts_at <= ?", office_close_time)
  end

  def today_meetings_list
    intro = "You have #{pluralize(today_meetings.length, 'meeting')} today \n"
    meetings_list = []
    meetings_list << intro
    today_meetings.map { |meeting|
      meetings_list << '1. ' + meeting.info["summary"] + ' ' + meeting.starts_at.strftime('%H:%M %p')
    }
    meetings_list.join("\n")
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
