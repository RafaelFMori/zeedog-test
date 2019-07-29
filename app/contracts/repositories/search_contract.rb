module Repositories
  class SearchContract < Dry::Validation::Contract
    ORDER_VALUES = ['asc','desc']
    SORT_VALUES = ['stars','forks','updated']

    params do
      optional(:page).value(:integer)
      optional(:per_page).value(:integer)
      optional(:sort).value(:string)
      optional(:order).value(:string)
      #"search parameters"
      optional(:language).value(:string)
      optional(:username).value(:string)
      optional(:label).value(:string)
    end

    rule(:language, :username, :label) do
      if !(values.key?(:language) | values.key?(:username) | values.key?(:label))
        key.failure("must have a search parameter - #{Message.info}")
      end
    end

    rule(:language) do
      if key?
        key.failure("language must not be blank - #{Message.info}") if value.blank?
      end
    end

    rule(:username) do
      if key?
        key.failure("username must not be blank - #{Message.info}") if value.blank?
      end
    end

    rule(:label) do
      if key?
        key.failure("label must not be blank - #{Message.info}") if value.blank?
      end
    end

    rule(:order, :sort) do
      if values[:order].present? and !values[:sort].present?
        key.failure("can only order sorted values - #{Message.info}")
      end
    end

    rule (:sort) do
      if key?
        key.failure(
          "must be: stars,forks or updated - #{Message.info}"
        ) if !SORT_VALUES.include? value
      end
    end

    rule(:order) do
      if key?
        key.failure(
          "must be desc or asc - #{Message.info}"
        ) if not ORDER_VALUES.include? value
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
