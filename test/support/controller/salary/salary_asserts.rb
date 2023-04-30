module SalaryAsserts
  def salary_response_asserts
    salary = Salary.find(response_data['id'])

    assert_equal salary_valid_keys, response_data.keys
    assert_equal salary.id, response_data['id']
    assert_equal salary.value, response_data['value'].to_f
    assert_equal salary.start_date.to_s, response_data['start_date']
    assert_equal salary.end_date.to_s, response_data['end_date']
  end
end
