module RenderErrorJson
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  end

  def render_error_json(object, status)
    render 'errors/error', locals: { object: object }, formats: :json, status: status
  end

  private

  def record_not_found(exception)
    render json: { error: 'Recurso no encontrado' }, status: :not_found
  end
end