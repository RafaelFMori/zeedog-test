module Repositories
  class ListContract < Dry::Validation::Contract
    TYPE_VALUES = ['public', 'private']

    params do
      optional(:page).value(:integer)
      optional(:per_page).value(:integer)
      optional(:type).value(:string)
    end

    rule(:type) do
      if key?
        key.failure(
          "must be public or private - #{Message.info}"
        ) if !TYPE_VALUES.include?(value)
      end
    end

    rule(:page) do
      if key?
        key.failure("must be equal or higher than 1 - #{Message.info}") if value < 1
      end
    end

    rule(:per_page) do
      if key?
        key.failure("must be equal or higher than 1 - #{Message.info}") if value < 1
        key.failure("must be equal or lower than 100 - #{Message.info}") if value > 100
      end
    end
  end
end
