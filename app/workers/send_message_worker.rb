class SendMessageWorker
  include Sidekiq::Worker

  def perform(send_to)
    API::SendMessage.new.execute(send_to, async: false)
  end
end