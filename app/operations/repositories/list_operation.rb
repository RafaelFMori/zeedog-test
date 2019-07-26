module Repositories
  class ListOperation
    include Dry::Transaction

    step :validate_contract
    step :build_query_parameters
    step :list
    step :result

    def validate_contract(context)
      if context[:contract].success?
        Success(context)
      else
        Failure(:invalid_contract)
      end
    end

    def build_query_parameters(context)
      query_string = "is:#{context[:contract][:type]}"
      context[:query_parameters] = {q: query_string}
      context[:query_parameters][:page] = context[:contract][:page]
      context[:query_parameters][:per_page] = context[:contract][:per_page]
      Success(context)
    end

    def list(context)
      request = HttpClient.new.get(
        base_url: 'https://api.github.com/search/repositories?',
        params: context[:query_parameters])

      if request.response.code == 200
        response_body = JSON.parse(request.response.body)
        context[:repositories] = response_body['items']
        Success(context)
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
