class SlackNotificationService
  @@configured = false

  def initialize
    configure unless @@configured
    @client = Slack::Web::Client.new
    test_authorization 
  end

  def notify_user(username, message)
    user_id = find_user_id(username)
    dm_channel = open_dm_channel(user_id)
    @client.chat_postMessage(
      channel: dm_channel.id,
      text: message
    )
  end

  private 

  def configure
    Slack.configure do |config|
      config.token = 'xoxb-408313172327-407278970530-yKfWAKxNcuXGUxyxUEb9ZYyk'
    end
    @@configured = true
  end

  def find_user_id(username)
    user_list = @client.users_list
    users = user_list.members.select { |member| member.profile.email == username }
    raise ArgumentError("Couldn't find a user with that email") if users.empty?
    users.first.id
  end

  def open_dm_channel(user_id)
    request = @client.im_open(user: user_id)
    request.channel
  end

  def test_authorization 
    @client.auth_test
  end
end
