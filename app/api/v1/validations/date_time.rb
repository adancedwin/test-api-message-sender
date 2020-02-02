class API::V1::Validations::DateTime < Grape::Validations::Base
  def validate_param!(attr_name, params)
    result = Time.parse(params[attr_name]) rescue false
    unless result
      fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "date must be of a valid format, example '2020-02-02 21:33:57.917883 +0300'"
    end
  end
end