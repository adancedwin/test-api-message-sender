class API < Grape::API
  namespace :v1 do
    default_format :json
    format :json
    content_type :json, 'application/json'

    mount API::V1::MessageResource
  end
end