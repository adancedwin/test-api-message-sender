class API::V1::Validations::ExactLength < Grape::Validations::Base
  def validate_param!(attr_name, params)
    unless params[attr_name].length == @option
      fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "must be #{@option} characters long"
    end
  end
end