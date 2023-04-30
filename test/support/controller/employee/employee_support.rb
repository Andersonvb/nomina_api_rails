module EmployeeSupport
  def employee_params
    company_id = companies(:company_one).id

    {
      employee: {
        company_id: company_id,
        name: 'EmployeeOne',
        lastname: 'EmployeeOne',
        salary: 750000,
        start_date: '2023-01-01',
        end_date: '2023-06-01'
      }
    }
  end

  def employee_valid_keys
    %w[id company name lastname start_date end_date]
  end
end
