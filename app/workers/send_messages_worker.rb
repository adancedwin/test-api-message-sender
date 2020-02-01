class SendMessagesWorker
  include Sidekiq::Worker

  def perform(message, send_to)
    API::SendMessage.new.execute(message, send_to, async: false)
  end
end