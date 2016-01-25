class TwilioClient
  def initialize
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  def send_message(phone, message)
    @client.messages.create(
      to: phone,
      from: ENV['TWILIO_PHONE_NUMBER'],
      body: message
    )
  end
end
