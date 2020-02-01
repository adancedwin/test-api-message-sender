class API::Stubs::Telegram < Grape::API
  RANDOM_SEND = [2, 3, 4, 6]

  namespace :telegram do
    desc 'Stub to send message through Telegram, 20% chance of failure'
    params do
      requires :message, type: String, desc: 'Message to send'
      optional :phone_number, type: String, desc: "User's Phone number"
    end
    post '/message' do
      if RANDOM_SEND.sample.even?
        status 200
        {
          status: 200,
          message: 'telegram - ok'
        }.to_json
      else
        status 503
        {
          status: 504,
          message: 'telegram - service unavailable'
        }.to_json
      end
    end
  end
end