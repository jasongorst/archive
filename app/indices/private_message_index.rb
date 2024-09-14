ThinkingSphinx::Index.define :private_message, with: :real_time do
  indexes text

  has user_id, type: :integer
  has user_ids, type: :integer, multi: true
  has private_channel_id, type: :integer
  has posted_on, type: :timestamp
  has posted_at, type: :timestamp
end
