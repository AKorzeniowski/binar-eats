Slack.configure do |config|
  if Rails.env.test?
    config.token = 'whatanicetoken'
  else 
    config.token = Rails.application.credentials.slack[:bot_token]
  end

end