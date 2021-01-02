ThinkingSphinx::Index.define :message, :with => :real_time do
  indexes text

  has user_id, type: :integer
  has channel_id, type: :integer
  has posted_at, type: :timestamp
end
