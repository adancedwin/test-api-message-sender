class API::V1::Validations::MessengerType < Grape::Validations::Base
  def validate_param!(attr_name, params)
    unless @option.include?(params[attr_name]) 
      fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "#{params[attr_name]} is unsupported messenger type"
    end
  end
end