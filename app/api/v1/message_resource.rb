class API::V1::MessageResource < API::V1::Base
  desc 'request to message users of provided messenger types'
  params do
    requires :message, type: String, desc: 'Message to send'
    optional :schedule_at, type: String, desc: 'DateTime to schedule when a message should be sent'
    group :send_to, type: Array do
      requires :messenger_type, type: String, desc: 'Messenger type'
      requires :uid, type: String, desc: 'uid - phone number'
    end
  end
  post '/message' do
    status 200
    {
      status: 200,
      message: 'ok'
    }
  end
end