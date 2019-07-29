require 'rails_helper'

RSpec.describe Repositories::SearchContract do

  let(:search_params) { { language: 'ruby', username: 'jhon', label: 'doe',
                          page: 1, per_page: 5, sort: 'stars', order: 'asc'} }

  let(:search_contract) { Repositories::SearchContract.new() }

  describe 'Validate contract' do

    context 'receive valid parameters' do
      it 'returns success' do
        expect(search_contract.call(search_params).success?).to eq(true)
      end

      it 'accepts one search parameter' do
        request_params = search_params.except(:username)
        expect(search_contract.call(search_params).success?).to eq(true)
      end

      it 'accepts more than one search parameter' do
        request_params = search_params.except(:username, :label)
        expect(search_contract.call(search_params).success?).to eq(true)
      end

      it 'returns success on required parameters only' do
        request_params = search_params.except(:label, :page, :per_page, :sort, :order)
        expect(search_contract.call(search_params).success?).to eq(true)
      end
    end

    context 'receive invalid parameters' do
      it 'returns failure ' do
        expect(search_contract.call(Hash.new).failure?).to eq(true)
      end

      it 'needs a search parameter' do
        request_params = search_params.except(:language, :username, :label)
        expect(
          search_contract.call(request_params).errors[:language][0]
        ).to eq("must have a search parameter - #{Message.info}")
      end
    end

    context 'receive unpermitted values on parameters' do
      it 'order receives an unpermited value' do
        expect(
          search_contract.call(sort:'stars', order: 'test').errors[:order][0]
        ).to eq("must be desc or asc - #{Message.info}")
      end

      it 'sort receives an unpermited value' do
        expect(
          search_contract.call(sort: 'test').errors[:sort][0]
        ).to eq("must be: stars,forks or updated - #{Message.info}")
      end

      it 'receives a lower than 1 value for page' do
        expect(
          search_contract.call(page: 0).errors[:page][0]
        ).to eq("must be equal or higher than 1 - #{Message.info}")
      end

      it 'receives a lower than 1 value for per_page' do
        expect(
          search_contract.call(per_page: 0).errors[:per_page][0]
        ).to eq("must be equal or higher than 1 - #{Message.info}")
      end

      it 'receives a higher than 100 value for per_page' do
        expect(
          search_contract.call(per_page: 155).errors[:per_page][0]
        ).to eq("must be equal or lower than 100 - #{Message.info}")
      end

      it 'receives a blank language parameter' do
        expect(
          search_contract.call(language: '').errors[:language][0]
        ).to eq("language must not be blank - #{Message.info}")
      end

      it 'receives a blank username parameter' do
        expect(
          search_contract.call(username: '').errors[:username][0]
        ).to eq("username must not be blank - #{Message.info}")
      end

      it 'receives a blank label parameter' do
        expect(
          search_contract.call(label: '').errors[:label][0]
        ).to eq("label must not be blank - #{Message.info}")
      end

      it 'receives order without sort' do
        expect(
          search_contract.call(order: 'asc').errors[:order][0]
        ).to eq("can only order sorted values - #{Message.info}")
      end
    end
  end
end
