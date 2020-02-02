class API::Wrappers::MessengersStub
  class MessageSendingError < StandardError; end

  include HTTParty

  base_uri 'localhost:3000'
  MESSENGERS_PATHS = {
    'whatsapp' => '/stubs/whatsapp/message',
    'viber' => '/stubs/viber/message',
    'telegram' => '/stubs/telegram/message'
  }
  
  def initialize(send_to)
    @delivery = MessagingRequestDelivery.find_by(
        messaging_request_id: send_to['request_id'],
        messenger_type: send_to['messenger_type']
    )
    @payload = {message: send_to['message'], phone_number: send_to['phone_number']}
    @path = MESSENGERS_PATHS[send_to['messenger_type']]
  end  
    
  def message
    @delivery.failed? ? @delivery.retry! : @delivery.start!

    result = self.class.post(
      @path,
      body: @payload,
      options: { headers: { 'Content-Type' => 'application/json' }}
    )

    unless JSON.parse(result.parsed_response)['status'] == 200
      @delivery.update(failed_attempts: @delivery.failed_attempts + 1)
      if @delivery.failed_attempts == (MessagingRequestDelivery::RETRY_LIMIT + 1)
        @delivery.finish_failure!
      else
        @delivery.fail!
      end

      raise API::Wrappers::MessengersStub::MessageSendingError # rails exception so Sidekiq treats it as a fail and retries the job
    end

    @delivery.finish_success!
  end
end