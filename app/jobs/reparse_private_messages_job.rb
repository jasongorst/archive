class ReparsePrivateMessagesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PrivateMessage.where("verbatim like '%\\u0026%'").find_each do |private_message|
      verbatim = Hashie::Mash.new(JSON.parse(private_message.verbatim))

      slack_message = Slack::Message.new(verbatim)
      next if slack_message.user.nil?

      private_message.text = slack_message.text
      private_message.save!
    end
  end
end
