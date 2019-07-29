module Auth
  class AuthenticateContract < Dry::Validation::Contract
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    params do
      required(:email).value(:string)
      required(:password).value(:string)
    end

    rule(:email) do
      key.failure("must be a valid email - #{Message.info}") if !VALID_EMAIL_REGEX.match(value)
    end
  end
end
