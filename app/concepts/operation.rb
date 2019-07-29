class Operation
  include Dry::Transaction

  def validate_contract(context)
    if context[:contract].success?
      Success(context)
    else
      Failure(:invalid_contract)
    end
  end
  
end
