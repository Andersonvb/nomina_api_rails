module SalarySupport
  def salary_params
    employee_id = employees(:employee_one).id

    {
      salary: {
        employee_id: employee_id,
        value: 750000,
        start_date: '2023-04-01',
        end_date: '2023-05-01'
      }
    }
  end

  def salary_valid_keys
    %w[id employee value start_date end_date]
  end
end
