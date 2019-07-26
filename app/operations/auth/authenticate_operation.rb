module Auth
  class AuthenticateOperation
    include Dry::Transaction

    step :validate_contract
    step :authenticate

    def validate_contract(context)
      if context[:contract].success?
        Success(context)
      else
        Failure(:invalid_contract)
      end
    end

    def authenticate(context)
      contract = context[:contract]
      auth_token = context[:authenticator].new.(contract[:email], contract[:password])
      Success(auth_token: auth_token)
    end
  end
end
