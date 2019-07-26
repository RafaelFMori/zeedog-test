require 'rails_helper'

RSpec.describe Repositories::SearchOperation do

  let(:search_params) { { search_options: 'language:ruby+user:jekyll+label:jekyll',
                          page: 1, per_page: 5, sort: 'stars', order: 'asc'} }

  describe 'Calls SearchOperation' do
    context 'it receives right parameters' do
      before do
        context = {contract: Repositories::SearchContract.new.(search_params)}
        @operation = Repositories::SearchOperation.new.(context)
      end

      it 'succeeds' do
        expect(@operation.success?).to eq(true)
      end
    end

    context 'receives wrong parameters' do
      before do
        context = {contract: Repositories::SearchContract.new.({})}
        @operation = Repositories::SearchOperation.new.(context)
      end

      it 'fails' do
        assert(@operation.failure?)
      end

      it 'returns an error message' do
        expect(@operation.failure).to eq(:invalid_contract)
      end
    end
  end
end
