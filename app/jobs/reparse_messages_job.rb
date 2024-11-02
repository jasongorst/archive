class ReparseMessagesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Message.find_each do |message|
      verbatim = Hashie::Mash.new(JSON.parse(message.verbatim))
      next unless /:[\w+-_]+?:/ =~ verbatim.text

      slack_message = Slack::Message.new(verbatim)
      next if slack_message.user.nil?

      message.text = slack_message.text
      message.save!
    end
  end
end
