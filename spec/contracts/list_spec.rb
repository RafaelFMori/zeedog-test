require 'rails_helper'

RSpec.describe Repositories::ListContract do

  let(:wrong_params) { { page: 'jhon', per_page: 'doe' } }
  let(:right_params) { { page: 1, per_page: 5} }
  let(:list_contract) { Repositories::ListContract.new() }

  describe 'Validate contract' do

    context 'receives valid parameters' do
      it 'returns success' do
        expect(list_contract.call(right_params).success?).to eq(true)
      end

      it 'returns success without optional parameters' do
        expect(list_contract.call(Hash.new).success?).to eq(true)
      end
    end

    context 'receives invalid parameters' do
      it 'returns failure ' do
        expect(list_contract.call(wrong_params).failure?).to eq(true)
      end
    end

    context 'receives unpermitted values on parameters ' do
      it 'value for type is not permitted' do
        expect(
          list_contract.call(type: 'test').errors[:type][0]
        ).to eq("must be public or private - #{Message.info}")
      end

      it 'value for page lower than 1 value for page' do
        expect(
          list_contract.call(page: 0).errors[:page][0]
        ).to eq("must be equal or higher than 1 - #{Message.info}")
      end

      it 'value for per_page lower than 1' do
        expect(
          list_contract.call(per_page: 0).errors[:per_page][0]
        ).to eq("must be equal or higher than 1 - #{Message.info}")
      end

      it 'value for per_page higher than 100' do
        expect(
          list_contract.call(per_page: 155).errors[:per_page][0]
        ).to eq("must be equal or lower than 100 - #{Message.info}")
      end
    end
  end
end
