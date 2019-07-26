module Repositories
  class SearchOperation
    include Dry::Transaction

    step :validate_contract
    step :build_search_query
    step :build_request_params
    step :search
    step :result

    def validate_contract(context)
      if context[:contract].success?
        Success(context)
      else
        Failure(:invalid_contract)
      end
    end

    def build_search_query(context)
      search_query = ''
      search_options = context[:contract][:search_options].split(' ')

      search_options.each do |opt|
        if !opt.include?('label')
          search_query += "#{opt}+"
        else
          label = opt.split(':')[1]
          search_query += "#{label}in:name+#{label}in:description+#{label}in:readme"
        end
      end

      context[:search] = search_query
      Success(context)
    end

    def build_request_params(context)
      context[:query_parameters] = {q: context[:search]}
      context[:query_parameters][:page] = context[:contract][:page]
      context[:query_parameters][:per_page] = context[:contract][:per_page]
      context[:query_parameters][:sort] = context[:contract][:sort] if context[:contract][:sort].present?
      context[:query_parameters][:order] = context[:contract][:order] if context[:contract][:order].present?

      Success(context)
    end

    def search(context)
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
