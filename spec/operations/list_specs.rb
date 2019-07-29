require 'rails_helper'

RSpec.describe Repositories::ListOperation do

  let(:public_params) { { type: 'public', page: 5, per_page: 50} }
  let(:private_params) { { type: 'private', page: 5, per_page: 50} }
  let(:unpermitted_params) { {type: 'secret', page: 5, per_page: 50} }
  let(:failing_params) { { type: 1, page: '1', per_page: '5'} }

  describe '#validate_contract' do
    context 'receives right parameters' do
      before do
        @context = {contract: Repositories::ListContract.new.(public_params)}
        @operation = Repositories::ListOperation.new.validate_contract(@context)
      end

      it 'succeeds' do
        expect(@operation.success?).to eq(true)
      end
    end

    context 'receives wrong parameters' do
      before do
        @context = {contract: Repositories::ListContract.new.(failing_params)}
        @operation = Repositories::ListOperation.new.validate_contract(@context)
      end

      it 'fails' do
        expect(@operation.failure?).to eq(true)
      end

      it 'returns an invalid contract message' do
        expect(@operation.failure).to eq(:invalid_contract)
      end
    end

    context 'receives no parameters' do
      before do
        @context = {contract: Repositories::ListContract.new.({})}
        @operation = Repositories::ListOperation.new.validate_contract(@context)
      end

      it 'succeds' do
        expect(@operation.success?).to eq(true)
      end
    end
  end

  describe '#build_request_params' do
    before do
      @context = {contract: Repositories::ListContract.new.(public_params)}
      @operation = Repositories::ListOperation.new.build_request_params(@context)
    end
    context 'all parameters are filled' do
      it 'returns the query_params' do
        expect(@context).to have_key(:query_parameters)
      end

      it 'uses the filled type parameter' do
        expect(@context[:query_parameters][:q]).to eq('is:public')
      end

      it 'uses the filled page parameter' do
        expect(@context[:query_parameters][:page]).to eq(5)
      end

      it 'uses the filled per_page parameter' do
        expect(@context[:query_parameters][:per_page]).to eq(50)
      end
    end

    context 'no parameter is filled' do
      before do
        @context = {contract: Repositories::ListContract.new.({})}
        @operation = Repositories::ListOperation.new.build_request_params(@context)
      end

      it 'succeeds' do
        expect(@operation.success?).to eq(true)
      end

      it 'returns the query_params' do
        expect(@context).to have_key(:query_parameters)
      end

      it 'uses the filled type parameter' do
        expect(@context[:query_parameters][:q]).to eq('is:public')
      end

      it 'uses the filled page parameter' do
        expect(@context[:query_parameters][:page]).to eq(1)
      end

      it 'uses the filled per_page parameter' do
        expect(@context[:query_parameters][:per_page]).to eq(30)
      end
    end

    context 'some parameter are filled' do
      before do
        @operation = Repositories::ListOperation.new
      end

      it 'does not receive the page parameter' do
        context = {contract: Repositories::ListContract.new.(private_params.except(:page))}
        @operation.build_request_params(context)
        expect(
          context[:query_parameters]
        ).to eq({ q: 'is:private', page: 1, per_page: 50})
      end

      it 'does not receive the per_page parameter' do
        context = {contract: Repositories::ListContract.new.(private_params.except(:per_page))}
        @operation.build_request_params(context)
        expect(
          context[:query_parameters]
        ).to eq({ q: 'is:private', page: 5, per_page: 30})
      end

      it 'does not receive the type parameter' do
        context = {contract: Repositories::ListContract.new.(private_params.except(:type))}
        @operation.build_request_params(context)
        expect(
          context[:query_parameters]
        ).to eq({ q: 'is:public', page: 5, per_page: 50})
      end
    end
  end

  describe '#list' do
    context 'finds repositories' do
      before do
        @context = {contract: Repositories::ListContract.new.(public_params)}
        @operation = Repositories::ListOperation.new
        @operation.build_request_params(@context)
        @operation.list(@context)
      end
      it 'returns repositories' do
        expect(@context).to have_key(:repositories)
      end
    end

    context 'did not find any repositories' do
      before do
        @context = {contract: Repositories::ListContract.new.(unpermitted_params)}
        @operation = Repositories::ListOperation.new.(@context)
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
