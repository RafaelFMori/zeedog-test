module Repositories
  class ListContract < Dry::Validation::Contract
    TYPE_VALUES = ['public','private']

    params do
      optional(:page).value(:integer)
      optional(:per_page).value(:integer)
      optional(:type).value(:string)
    end

    rule(:type) do
      if key?
        key.failure('must be public or private') if !TYPE_VALUES.include?(value)
      end
    end

    rule(:type) do
      if key?
        key.failure('must not be blank') if value.blank?
      end
    end

    rule(:page) do
      if key?
        key.failure('must be a positive number') if value < 0
      end
    end

    rule(:per_page) do
      if key?
        key.failure('must be a positive number') if value < 0
        key.failure('limit is 100') if value > 100
      end
    end
  end
end
