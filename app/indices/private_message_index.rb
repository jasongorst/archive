ThinkingSphinx::Index.define :private_message, with: :real_time do
  indexes text

  has user_id, type: :integer
  has private_channel_id, type: :integer
  has posted_on, type: :timestamp
  has posted_at, type: :timestamp
end
