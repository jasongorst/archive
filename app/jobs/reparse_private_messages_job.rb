class ReparsePrivateMessagesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PrivateMessage.find_each do |private_message|
      verbatim = Hashie::Mash.new(JSON.parse(private_message.verbatim))
      next unless /:[\w+-_]+?:/ =~ verbatim.text

      slack_message = Slack::Message.new(verbatim)
      next if slack_message.user.nil?

      private_message.text = slack_message.text
      private_message.save!
    end
  end
end
