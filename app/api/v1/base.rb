class API::V1::Base < Grape::API
  def self.inherited(subclass)
    super

    subclass.instance_eval do
      before do
        header 'Access-Control-Allow-Origin', '*'
        header 'Access-Control-Allow-Methods', 'POST'
        header 'Access-Control-Allow-Headers',
               'Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With'
      end

      helpers do
        def error_422!(source)
          source = {_: source} if source.is_a?(String)

          error!(
              {
                  errors: {
                      status: 422,
                      source: source,
                      title: 'Validation Failed',
                  },
              },
              422
          )
        end

        def error_403!(title = 'Forbidden')
          error!(
              {
                  errors: {
                      status: 403,
                      title: title,
                  },
              },
              403
          )
        end

        def error_500!(message)
          error!(
              {
                  errors: {
                      status: 500,
                      title: message,
                  },
              },
              500
          )
        end
      end
    end
  end
end