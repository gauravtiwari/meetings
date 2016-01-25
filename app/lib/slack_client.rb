class SlackClient
  def initialize(token)
    @client = Slack::Web::Client.new
    @client.token = token
  end

  def post_message(uid, message)
    @client.chat_postMessage(
      channel: uid,
      text: message,
      mrkdwn: true,
      as_user: false
    )
  end
end
