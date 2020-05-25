json.extract! channel, :id, :slack_channel, :name, :created_at, :updated_at
json.url channel_url(channel, format: :json)
