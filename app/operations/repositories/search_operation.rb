module Repositories
  class SearchOperation < Operation
    include Dry::Transaction
    DEFAULT_LANGUAGE = 'ruby'
    LABEL_SOURCES = ['readme','name','description']
    DEFAULT_PAGE_VALUE = 1
    DEFAULT_PER_PAGE_VALUE = 30

    step :validate_contract
    step :build_search_query
    step :build_request_params
    step :search
    step :result

    def build_search_query(context)
      search = ''
      contract = context[:contract]

      search += "user:#{contract[:username]}+" if contract.key?(:username)
      if contract.key?(:label)
        LABEL_SOURCES.each {|source| search += "#{contract[:label]}in:#{source}+"}
      end
      if contract.key?(:language)
        contract[:language] = DEFAULT_LANGUAGE if contract[:language].blank?
        search += "language:#{contract[:language]}+"
      end

      context[:search] = search
      Success(context)
    end

    def build_request_params(context)
      contract = context[:contract]
      contract.values[:page] = DEFAULT_PAGE_VALUE if !contract.key?(:page)
      contract.values[:per_page] = DEFAULT_PER_PAGE_VALUE if !contract.key?(:per_page)

      context[:query_parameters] = {q: context[:search]}
      context[:query_parameters][:page] = contract[:page]
      context[:query_parameters][:per_page] = contract[:per_page]
      context[:query_parameters][:sort] = contract[:sort] if contract[:sort].present?
      context[:query_parameters][:order] = contract[:order] if contract[:order].present?

      Success(context)
    end

    def search(context)
      request = HttpClient.new.get(
        base_url: 'https://api.github.com/search/repositories?',
        params: context[:query_parameters])

      response_body = JSON.parse(request.response.body)
      
      if response_body['items'].present?
        context[:repositories] = response_body['items']
        Success(context)
      else
        Failure(:not_found)
      end
    end

    def result(context)
      repositories_list = []
      repositories = context[:repositories]
      repositories.each do |repository|
        repositories_list << {
            name: repository['full_name'],
            description: repository['description'],
            stars: repository['stargazers_count'],
            forks:repository['forks_count'],
            author:repository['owner']['login']
        }
      end
      result = {page: context[:contract][:page], repositories: repositories_list}
      Success(result)
    end
  end
end
