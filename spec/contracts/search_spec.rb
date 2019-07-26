require 'rails_helper'

RSpec.describe Repositories::SearchContract do

  let(:search_params) { { search_options: 'language:ruby+user:jhon+label:doe',
                          page: 1,
                          per_page: 5,
                          sort: 'stars',
                          order: 'asc'} }

  let(:search_contract) { Repositories::SearchContract.new() }

  describe 'Validate contract' do

    context 'receive valid parameters' do
      it 'returns success' do
        expect(search_contract.call(search_params).success?).to eq(true)
      end

      it 'return success without optional parameters' do
        expect(
          search_contract.call(
            search_options: 'language:ruby+user:jhon+label:doe'
          ).success?
        ).to eq(true)
      end
    end

    context 'receive invalid parameters' do
      it 'returns failure ' do
        expect(search_contract.call(Hash.new).failure?).to eq(true)
      end

      it 'receives a empty search_options' do
        expect(
          search_contract.call(Hash.new).errors[:search_options][0]
        ).to eq('is missing')
      end

      it 'order receives an unpermited value' do
        expect(
          search_contract.call(sort:'stars', order: 'test').errors[:order][0]
        ).to eq('must be desc or asc')
      end

      it 'sort receives an unpermited value' do
        expect(
          search_contract.call(sort: 'test').errors[:sort][0]
        ).to eq('must be: stars,forks or updated')
      end

      it 'receives order without sort' do
        expect(
          search_contract.call(order: 'asc').errors[:order][0]
        ).to eq('can only order sorted values')
      end

      it 'receives the wrong type of parameter' do
        expect(
          search_contract.call(search_options: 1).errors[:search_options][0]
        ).to eq("must be a string")
      end
    end
  end
end
