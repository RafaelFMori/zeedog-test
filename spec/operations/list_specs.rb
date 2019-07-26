require 'rails_helper'

RSpec.describe Repositories::ListOperation do

  let(:search_params) { { search_options: 'language:ruby+user:jekyll+label:jekyll',
                          page: 1, per_page: 5, sort: 'stars', order: 'asc'} }

  describe 'Calls ListOperation' do
    context 'it receives right parameters' do
      before do
        context = {contract: Repositories::ListContract.new.(search_params)}
        @operation = Repositories::ListOperation.new.(context)
      end

      it 'succeeds' do
        expect(@operation.success?).to eq(true)
      end
    end

    context 'receives wrong parameters' do
      before do
        context = {contract: Repositories::ListContract.new.({})}
        @operation = Repositories::ListOperation.new.(context)
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
