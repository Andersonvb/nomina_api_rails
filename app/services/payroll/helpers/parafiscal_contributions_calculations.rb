module ParafiscalContributionsCalculations
  def calculate_parafiscal_contributions(incomes)
    compensation_fund = incomes[:total_social_security_and_parafiscal_base] * 0.04

    icbf_percentage = incomes[:total_social_security_ratio] < 10 ? 0 : 0.03
    icbf = incomes[:total_social_security_and_parafiscal_base] * icbf_percentage

    sena_percentage = incomes[:total_social_security_ratio] < 10 ? 0 : 0.02
    sena = incomes[:total_social_security_and_parafiscal_base] * sena_percentage

    total_parafiscal_contributions = compensation_fund + icbf + sena

    {
      compensation_fund: compensation_fund,
      icbf: icbf,
      sena: sena,
      total: total_parafiscal_contributions
    }
  end
end
