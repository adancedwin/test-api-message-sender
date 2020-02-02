class API::V1::MessageResource < API::V1::Base
  MESSENGERS = %w[
    viber
    whatsapp
    telegram
  ].freeze

  desc 'request to message users of provided messenger types'
  params do
    requires :message, type: String, desc: 'Message to send'
    optional :schedule_at, type: String, desc: 'DateTime to schedule_at when a message should be sent'
    group :send_to, type: Array do
      requires :messenger_type, type: String, desc: 'Messenger type'
      requires :phone_number, type: String, desc: 'phone_number - phone number'
    end
  end
  post '/message' do
    send_to = params[:send_to].inject([]) do |acc, receiver|
      receiver['message'] = params[:message]
      acc << [receiver] if MESSENGERS.include?(receiver[:messenger_type].downcase)
    end
    puts send_to

    API::SendMessage.new.execute(
      send_to,
      schedule_at: params[:schedule_at],
      async: true
    )

    status 200
    {
      status: 200,
      message: 'ok'
    }.to_json
  end
end