module PeriodSupport
  def period_params
    company_id = companies(:company_one).id

    {
      period: {
        company_id: company_id,
        start_date: '2023-02-01',
        end_date: '2023-02-27'
      }
    }
  end

  def period_valid_keys
    %w[id company start_date end_date]
  end
end
