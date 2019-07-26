module Repositories
  class SearchContract < Dry::Validation::Contract
    include Dry::Validation
    ORDER_VALUES = ['asc','desc']
    SORT_VALUES = ['stars','forks','updated']
    #dry contract does not have a built-in way to whitelist parameters
    PERMITTED_PARAMETERS = ['page','per_page','sort','order','search_options']

    params do
      optional(:page).value(:integer)
      optional(:per_page).value(:integer)
      optional(:sort).value(:string)
      optional(:order).value(:string)
      required(:search_options).value(:string)
    end

    rule(:order, :sort) do
      if values[:order].present? and !values[:sort].present?
        key.failure('can only order sorted values')
      end
    end

    rule(:search_options) do
      key.failure('must not be blank') if value.blank?
    end

    rule (:sort) do
      if key?
        key.failure('must be: stars,forks or updated') if !SORT_VALUES.include? value
      end
    end

    rule(:order) do
      if key?
        key.failure('must be desc or asc') if not ORDER_VALUES.include? value
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
