class API < Grape::API
  namespace :v1 do
    default_format :json
    format :json
    content_type :json, 'application/json'

    mount API::V1::MessageResource
  end

  namespace :stubs do
    mount API::Stubs::Viber
    mount API::Stubs::WhatsApp
    mount API::Stubs::Telegram
  end
end