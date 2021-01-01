ThinkingSphinx::Index.define :message, :with => :real_time do
  indexes text
  # indexes user.display_name as: :name, sortable: true
  # indexes channel.name as: :channel, sortable: true

  has user_id, type: :integer
  has channel_id, type: :integer
  has posted_at, type: :timestamp
end
