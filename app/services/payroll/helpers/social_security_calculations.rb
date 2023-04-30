module SocialSecurityCalculations
  def calculate_social_security(incomes)
    health_percentage = incomes[:total_social_security_ratio] < 10 ? 0 : 0.085
    health = incomes[:total_social_security_and_parafiscal_base] * health_percentage

    pension = incomes[:total_social_security_and_parafiscal_base] * 0.12

    arl = incomes[:total_social_security_and_parafiscal_base] * 0.0696

    total_social_security = health + pension + arl

    {
      health: health,
      pension: pension,
      arl: arl,
      total: total_social_security
    }
  end
end
