class SlackNotificationService
  @@configured = false

  def initialize
    configure unless @@configured
    @client = Slack::Web::Client.new
    puts "[SLACK] Connection established" if test_authorization 
  end

  private 

  def configure
    Slack.configure do |config|
      config.token = 'xoxb-408313172327-407278970530-yKfWAKxNcuXGUxyxUEb9ZYyk'
    end
    puts "[SLACK] API connection configured"
    @@configured = true
  end

  def test_authorization 
    @client.auth_test
  end
end
