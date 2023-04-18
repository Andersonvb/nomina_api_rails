module StringValidations
  extend ActiveSupport::Concern

  def regex_valid_string
    /^[0-9a-zA-ZÑñáéíóúüÁÉÍÓÚ&-_ ]+$/
  end
end