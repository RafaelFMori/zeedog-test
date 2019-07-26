require 'rails_helper'

RSpec.describe Repositories::ListContract do

  let(:wrong_params) { { type: 1, page: 'jhon', per_page: 'doe' } }
  let(:right_params) { { type: 'public', page: 1, per_page: 5} }
  let(:list_contract) { Repositories::ListContract.new() }

  describe 'Validate contract' do

    context 'receive valid parameters' do
      it 'returns success' do
        expect(list_contract.call(right_params).success?).to eq(true)
      end

      it 'return success without optional parameters' do
        expect(list_contract.call(Hash.new).success?).to eq(true)
      end
    end

    context 'receive invalid parameters' do
      it 'returns failure ' do
        expect(list_contract.call(wrong_params).failure?).to eq(true)
      end

      it 'type receives an unpermited value' do
        expect(list_contract.call(type: 'test').errors[:type][0]).to eq('must be public or private')
      end

      it 'receives the wrong type of parameter' do
        expect(list_contract.call(type: 1).errors[:type][0]).to eq('must be a string')
      end
    end
  end
end
