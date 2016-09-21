class Api::V1::BaseController < ApplicationController

  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :not_found!

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

end
