json.extract! user, :id, :slack_user, :display_name, :color, :created_at, :updated_at
json.url user_url(user, format: :json)
