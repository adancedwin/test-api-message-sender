class API::V1::MessageResource < API::V1::Base
  require_relative 'validations/messenger_type'

  MESSENGERS = %w[
    viber
    whatsapp
    telegram
  ].freeze

  desc 'request to message users of provided messenger types'
  params do
    requires :message, min_length: 5, max_length: 4000, type: String, desc: 'Message to send'
    optional :schedule_at, type: String, date_time: true, desc: 'DateTime to schedule_at when a message should be sent'
    group :send_to, type: Array do
      requires :messenger_type, messenger_type: MESSENGERS, type: String, desc: 'Messenger type'
      requires :phone_number, exact_length: 14, type: String, desc: 'phone_number - phone number'
    end
  end
  post '/message' do
    send_to = params[:send_to].inject([]) do |acc, receiver|
      receiver['message'] = params[:message]
      acc << [receiver] if MESSENGERS.include?(receiver[:messenger_type].downcase)
    end
    API::SendMessage.new.execute(
      send_to,
      schedule_at: params[:schedule_at],
      async: true
    )

    status 200
    {
      message: 'request started processing'
    }
  end
end