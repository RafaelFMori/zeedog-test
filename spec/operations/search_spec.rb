require 'rails_helper'

RSpec.describe Repositories::SearchOperation do

  let(:search_params) { { language:'ruby', username:'jekyll', label:'jekyll',
                          page: 1, per_page: 50, sort: 'stars', order: 'asc'} }
  let(:failing_params) { { language:1, user:2, label:3, page: "one",
                           per_page: "two", sort: 'cookies', order: 'secret'} }
  let(:complete_search_string) {
    'user:jekyll+jekyllin:readme+jekyllin:name+jekyllin:description+language:ruby+'
  }

  describe '#validate_contract' do
    context 'receives right parameters' do
      before do
        @context = {contract: Repositories::SearchContract.new.(search_params)}
        @operation = Repositories::SearchOperation.new.validate_contract(@context)
      end

      it 'succeeds' do
        expect(@operation.success?).to eq(true)
      end
    end

    context 'receives wrong parameters' do
      before do
        @context = {contract: Repositories::SearchContract.new.(failing_params)}
        @operation = Repositories::SearchOperation.new.validate_contract(@context)
      end

      it 'fails' do
        expect(@operation.failure?).to eq(true)
      end

      it 'returns an invalid contract message' do
        expect(@operation.failure).to eq(:invalid_contract)
      end
    end

    context 'do not receive any parameter' do
      before do
        @context = {contract: Repositories::SearchContract.new.({})}
        @operation = Repositories::SearchOperation.new.validate_contract(@context)
      end

      it 'returns a failure' do
        expect(@operation.failure).to eq(:invalid_contract)
      end
    end

    context 'receives no parameters' do
      before do
        @context = {contract: Repositories::SearchContract.new.({})}
        @operation = Repositories::SearchOperation.new.validate_contract(@context)
      end

      it 'fails' do
        expect(@operation.failure).to eq(:invalid_contract)
      end
    end
  end

  describe '#build_request_params' do
    before do
      @context = {contract: Repositories::SearchContract.new.(search_params)}
      @operation = Repositories::SearchOperation.new
      @operation.build_search_query(@context)
      @operation.build_request_params(@context)
    end
    context 'all parameters are filled' do
      it 'returns the query_params' do
        expect(@context).to have_key(:query_parameters)
      end

      it 'uses the filled type parameter' do
        expect(@context[:query_parameters][:q]).to eq(complete_search_string)
      end

      it 'uses the filled page parameter' do
        expect(@context[:query_parameters][:page]).to eq(1)
      end

      it 'uses the filled per_page parameter' do
        expect(@context[:query_parameters][:per_page]).to eq(50)
      end

      it 'uses the filled order parameter' do
        expect(@context[:query_parameters][:order]).to eq('asc')
      end

      it 'uses the filled sort parameter' do
        expect(@context[:query_parameters][:sort]).to eq('stars')
      end
    end

    context 'only search parameters are required' do
      before do
        search_params_only = {language: 'ruby', username: 'jekyll', label: 'jekyll'}
        @context = {contract: Repositories::SearchContract.new.(search_params_only)}
        @operation = Repositories::SearchOperation.new
        @operation.build_search_query(@context)
        @operation.build_request_params(@context)
      end

      it 'returns the query_params' do
        expect(@context).to have_key(:query_parameters)
      end

      it 'uses the filled type parameter' do
        expect(@context[:query_parameters][:q]).to eq(complete_search_string)
      end

      it 'uses the filled page parameter' do
        expect(@context[:query_parameters][:page]).to eq(1)
      end

      it 'uses the filled per_page parameter' do
        expect(@context[:query_parameters][:per_page]).to eq(30)
      end
    end

    context 'some required parameter are filled' do
      before do
        @operation = Repositories::SearchOperation.new
      end

      it 'receive only the label parameter' do
        context = {contract: Repositories::SearchContract.new.(search_params.except(:language,:username))}
        @operation.build_search_query(context)
        @operation.build_request_params(context)
        expect(
          context[:query_parameters]
        ).to eq({ q: 'jekyllin:readme+jekyllin:name+jekyllin:description+',
                  page: 1,
                  per_page: 50,
                  sort: 'stars',
                  order:'asc'})
      end

      it 'receive only the language parameter' do
        context = {contract: Repositories::SearchContract.new.(search_params.except(:username, :label))}
        @operation.build_search_query(context)
        @operation.build_request_params(context)
        expect(
          context[:query_parameters]
        ).to eq({ q: 'language:ruby+', page: 1, per_page: 50, sort: 'stars', order:'asc'})
      end

      it 'receive only the username parameter' do
        context = {contract: Repositories::SearchContract.new.(search_params.except(:language, :label))}
        @operation.build_search_query(context)
        @operation.build_request_params(context)
        expect(
          context[:query_parameters]
        ).to eq({ q: 'user:jekyll+', page: 1, per_page: 50, sort: 'stars', order:'asc'})
      end
    end
  end

  describe '#search' do
    context 'finds repositories' do
      before do
        @context = {contract: Repositories::SearchContract.new.(search_params)}
        @operation = Repositories::SearchOperation.new.(@context)
      end

      it 'returns repositories' do
        expect(@context).to have_key(:repositories)
      end
    end

    context 'did not find any repositories' do
      before do
        @context = {contract: Repositories::SearchContract.new.(language:'asydfasudta')}
        @operation = Repositories::SearchOperation.new.(@context)
      end

      it 'returns no repositories' do
        expect(@context).to_not have_key(:repositories)
      end

      it 'returns a not_found message' do
        expect(@operation.failure).to eq(:not_found)
      end
    end
  end
end
