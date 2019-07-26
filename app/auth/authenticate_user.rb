#module Auth
  class AuthenticateUser
    def call(email, password)
      user = find_user(email, password)
      JsonWebToken.encode(user_id: user.id)
    end

    private

    def find_user(email, password)
      user = User.find_by(email: email)
      return user if user && user.authenticate(password)
      raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
    end
  end
#end
