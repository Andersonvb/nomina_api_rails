module PayrollSupport
  def payroll_params
    period_id = periods(:period_one).id
    employee_id = employees(:employee_one).id

    {
      payroll: {
        employee_id: employee_id,
        period_id: period_id,
        salary_income: 0,
        non_salary_income: 0,
        deductions: 0
      }
    }
  end

  def payroll_new_params
    period_id = periods(:period_two).id
    employee_id = employees(:employee_two).id

    {
      payroll: {
        employee_id: employee_id,
        period_id: period_id,
        salary_income: 0,
        non_salary_income: 0,
        deductions: 0
      }
    }
  end

  def payroll_valid_keys
    %w[id employee period salary_income non_salary_income deductions]
  end
end