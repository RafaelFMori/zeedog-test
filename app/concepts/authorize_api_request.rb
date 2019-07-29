class AuthorizeApiRequest

  def call(headers = {})
    auth_token = http_auth_header(headers)
    decoded_token = decoded_auth_token(auth_token)
    authorize(decoded_token)
  end

  private

  def authorize(decoded_auth_token)
    User.find_by!(id: decoded_auth_token[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    raise(
      ExceptionHandler::InvalidToken,
      ("#{Message.invalid_token} #{e.message}")
    )
  end

  def decoded_auth_token(auth_token)
    JsonWebToken.decode(auth_token)
  end

  def http_auth_header(headers)
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
      raise(ExceptionHandler::MissingToken, Message.missing_token)
  end
end
