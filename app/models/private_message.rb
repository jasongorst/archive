class PrivateMessage < ApplicationRecord
  validates :ts, presence: true, numericality: true

  belongs_to :private_channel
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  before_save :set_posted_at_and_posted_on

  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  paginates_per 50

  default_scope { order(posted_at: :asc) }

  def user_ids
    private_channel.users.pluck(:id)
  end

  private

  def set_posted_at_and_posted_on
    # times are in local server time
    # set in config/application.rb, see "config.time_zone ="
    self.posted_at = Time.zone.at(ts)
    self.posted_on = posted_at.to_date
  end
end
