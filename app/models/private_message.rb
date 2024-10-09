class PrivateMessage < ApplicationRecord
  validates :ts, presence: true, numericality: true
  encrypts :text
  encrypts :verbatim

  belongs_to :private_channel
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  before_save :set_posted_timestamps

  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  paginates_per 50

  default_scope { order(posted_at: :asc) }

  def user_ids
    private_channel.users.pluck(:id)
  end

  def index_by_date
    private_channel
      .private_messages_posted_on(self.posted_on).pluck(:posted_at)
      .bsearch_index { |time| time >= posted_at } + 1
  end

  def page_by_date(per_page = self.class.default_per_page)
    (index_by_date.to_f / per_page).ceil
  end

  private

  def set_posted_timestamps
    # times are in local server time
    # set in config/application.rb, see "config.time_zone ="
    self.posted_at = Time.zone.at(ts)
    self.posted_on = posted_at.to_date
  end
end
