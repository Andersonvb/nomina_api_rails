module CompanySupport
  def company_params
    user_id = users(:user_one).id

    {
      company: {
        user_id: user_id,
        name: "company_name"
      }
    }
  end

  def company_valid_keys
    %w[id user name]
  end
end