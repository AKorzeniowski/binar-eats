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
      config.token = ENV['SLACK_API_TOKEN']
    end
    puts "[SLACK] API connection configured"
    @@configured = true
  end
end
