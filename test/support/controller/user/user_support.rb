module UserSupport
  def user_params
    {
      user: {
        name: "user_name",
        lastname: "user_lastname",
        username: "username",
        password: "user_password"
      }
    }
  end

  def user_valid_keys
    %w[id name lastname username password]
  end
end