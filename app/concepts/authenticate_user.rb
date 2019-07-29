class AuthenticateUser
  def call(email, password)
    user = find_user(email, password)
    {auth_token: JsonWebToken.encode(user_id: user.id)} if user
  end

  private

  def find_user(email, password)
    user = User.find_by(email: email)
    return user if user && user.authenticate(password)
  end
end
