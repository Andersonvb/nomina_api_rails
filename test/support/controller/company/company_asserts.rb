module CompanyAsserts
  def company_response_asserts
    company = Company.find(response_data['id'])

    assert_equal company_valid_keys, response_data.keys
    assert_equal company.id, response_data['id']
    assert_equal company.name, response_data['name']
  end
end