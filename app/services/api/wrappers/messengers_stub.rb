class API::Wrappers::MessengersStub
  class MessageSendingError < StandardError; end

  include HTTParty

  base_uri 'localhost:3000'
  MESSENGERS_PATHS = {
    'whatsapp' => '/stubs/whatsapp/message',
    'viber' => '/stubs/viber/message',
    'telegram' => '/stubs/telegram/message'
  }

  def message(send_to)
    payload = {}
    payload[:message] = send_to['message']
    payload[:phone_number] = send_to['uid']
    result = self.class.post(
      MESSENGERS_PATHS[send_to['messenger_type']],
      body: payload,
      options: { headers: { 'Content-Type' => 'application/json' }}
    )

    raise API::Wrappers::MessengersStub::MessageSendingError unless JSON.parse(result.parsed_response)['status'] == 200
  end
end