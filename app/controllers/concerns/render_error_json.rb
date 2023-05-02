module RenderErrorJson
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  end

  def render_error_json(object, status)
    render 'errors/error', locals: { object: object }, formats: :json, status: status
  end

  def render_record_not_found
    render json: { error: [ message: 'Recurso no encontrado' ] }, status: :not_found
  end

  def render_invalid_id_error(attribute)
    render json: { error: [ message: "El #{attribute.to_s} no pertenece al usuario actual" ]}, status: :unprocessable_entity
  end

  def render_no_salary_for_period_error
    render json: { error: [ message: 'El empleado no tiene un salario para el periodo suministrado' ] }, status: :unprocessable_entity
  end
end
