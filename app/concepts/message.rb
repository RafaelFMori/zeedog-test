class Message
  def self.not_found(record = 'record')
    "Sorry, no #{record} was found."
  end

  def self.unknown_error
    "Sorry something went wrong"
  end

  def self.bad_request
    "Bad request - #{info}"
  end

  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.missing_token
    'Missing token'
  end

  def self.unauthorized
    'Unauthorized request'
  end

  def self.account_created
    'Account created successfully'
  end

  def self.account_not_created
    'Account could not be created'
  end

  def self.expired_token
    'Sorry, your token has expired. Please login to continue.'
  end

  def self.info(info_url = 'https://github.com/RafaelFMori/zeedog-test')
    "For more info visit: #{info_url} and read the api session of the readme doc"
  end
end
