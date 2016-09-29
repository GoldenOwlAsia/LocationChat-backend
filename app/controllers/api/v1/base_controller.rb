class Api::V1::BaseController < ApplicationController
  include ActionController::Serialization
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :not_found!

  skip_before_action :verify_authenticity_token

  private

  def authenticate!(resource_klass)
    auth_token, options = ActionController::HttpAuthentication::Token.token_and_options(request)

    resource = resource_klass.find_by(email: options&.dig(:email))

    result = TokenAuthService.new(resource, auth_token).call

    if result.success?
      @current_resource = resource
    else
      render_resource(result, status: 401)
    end
  end

  def not_found!
    render nothing: true, status: 404
  end

  def render_collection(collection, meta: nil, includes: [])
    render json: collection, status: status || 200, each_serializer: "Api::V1::#{collection.ancestors.first.name}Serializer".constantize, meta: meta, include: includes
  end

  def render_result(result, status: nil, includes: [])
    if result.errors.empty?
      render_resource(result.data, status: status, includes: includes)
    else
      render_resource(result)
    end
  end

  def render_resource(resource, status: nil, includes: [])
    if resource.errors.empty?
      render json: resource, status: status || (action_name == 'create' ? 201 : 200), serializer: "Api::V1::#{resource.class.name}Serializer".constantize, include: includes
    else
      render json: resource, status: status || 422, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def jsonapi_params(*args)
    params.require(:data).permit(:type, attributes: args)[:attributes] || {}
  end

  def authenticate_from_token!(resource_klass)
    auth_token = params[:auth_token].presence || ActionController::HttpAuthentication::Token.token_and_options(request)&.first
    resource = resource_klass.find_by(auth_token: auth_token)
    
    if auth_token && resource
      instance_variable_set("@#{resource_klass.to_s.downcase}", resource)
    else
      not_authenticated
    end
  end

  def not_found
    render json: { errors: 'Data not found' }, status: 404
  end

  def not_authenticated
    render json: {
      error_msg: "You're not authenticated/authorized"
    }, status: 401
  end

end
