module Repositories
  class ListOperation < Operation
    DEFAULT_PAGE_VALUE = 1
    DEFAULT_PER_PAGE_VALUE = 30
    DEFAULT_TYPE = 'public'

    step :validate_contract
    step :build_request_params
    step :list
    step :result

    def build_request_params(context)
      contract = context[:contract]
      contract.values[:type] = DEFAULT_TYPE if !contract.key?(:type)
      contract.values[:page] = DEFAULT_PAGE_VALUE if !contract.key?(:page)
      contract.values[:per_page] = DEFAULT_PER_PAGE_VALUE if !contract.key?(:per_page)

      context[:query_parameters] = {q: "is:#{contract[:type]}"}
      context[:query_parameters][:page] = contract[:page]
      context[:query_parameters][:per_page] = contract[:per_page]
      Success(context)
    end

    def list(context)
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
            forks: repository['forks_count'],
            author:repository['owner']['login']
        }
      end
      result = {page: context[:contract][:page], repositories: repositories_list}
      Success(result)
    end
  end
end
