class GoogleClient
  def initialize
    @calendar = Google::Apis::CalendarV3::CalendarService.new
  end

  def fetch_events(from_time, token)
    @calendar.list_events(
      'primary',
      always_include_email: true,
      single_events: false,
      order_by: 'updated',
      time_min: Time.now.iso8601,
      time_max: from_time,
      options: {
        authorization: token
      }
    )
  end
end
