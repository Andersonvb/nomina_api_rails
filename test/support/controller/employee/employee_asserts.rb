module EmployeeAsserts
  def employee_response_asserts
    employee = Employee.find(response_data['id'])

    assert_equal employee_valid_keys, response_data.keys
    assert_equal employee.id, response_data['id']
    assert_equal employee.name, response_data['name']
    assert_equal employee.lastname, response_data['lastname']
    assert_equal employee.start_date.to_s, response_data['start_date']
    assert_equal employee.end_date.to_s, response_data['end_date']
  end
end
