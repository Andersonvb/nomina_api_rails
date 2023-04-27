module PeriodAsserts
  def period_response_asserts
    period = Period.find(response_data['id'])

    assert_equal period_valid_keys, response_data.keys
    assert_equal period.id, response_data['id']
    assert_equal period.start_date.to_s, response_data['start_date']
    assert_equal period.end_date.to_s, response_data['end_date']
  end
end
