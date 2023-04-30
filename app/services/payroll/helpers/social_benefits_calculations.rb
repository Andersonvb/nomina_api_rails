module SocialBenefitsCalculations
  def calculate_social_benefits(incomes)
    severance_pay = (incomes[:social_benefits_total_base] * 0.08333333333).round

    interest_on_severance_pay = (severance_pay * 0.12).round

    service_bonus = (incomes[:social_benefits_total_base] * 0.08333333333).round

    vacation = (incomes[:total_social_security_and_parafiscal_base] * 0.04166666667).round

    total_social_benefits = severance_pay + interest_on_severance_pay + service_bonus + vacation

    {
      severance_pay: severance_pay,
      interest_on_severance_pay: interest_on_severance_pay,
      service_bonus: service_bonus,
      vacation: vacation,
      total: total_social_benefits
    }
  end
end
