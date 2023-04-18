module RenderErrorJson
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  end

  def render_error_json(object, status)
    render 'errors/error', locals: { object: object }, formats: :json, status: status
  end

  private

  def record_not_found(exception)
    render_error_json(exception.message, :not_found)
  end

  def record_invalid(exception)
    render_error_json(exception.message, :unprocessable_entity, exception.record)
  end
end