module SocialSecurityCalculations
  def calculate_social_security(total_social_security_and_parafiscal_base, total_social_security_ratio)
    social_security_health_percentage = total_social_security_ratio < 10 ? 0 : 0.085
    social_security_health = total_social_security_and_parafiscal_base * social_security_health_percentage

    social_security_pension = total_social_security_and_parafiscal_base * 0.12

    arl = total_social_security_and_parafiscal_base * 0.0696

    total_social_security = social_security_health + social_security_pension + arl

    {
      health: social_security_health,
      pension: social_security_pension,
      arl: arl,
      total: total_social_security
    }
  end
end