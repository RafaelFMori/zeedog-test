require 'rails_helper'

RSpec.describe Auth::AuthenticateContract do

  let(:params) { { email: "jhon@doe.com", password: "foobar" } }
  let(:auth_contract) { Auth::AuthenticateContract.new() }

  describe 'Validate contract' do

    context 'receive valid parameters' do
      it 'returns success' do
        expect(auth_contract.call(params).success?).to eq(true)
      end
    end

    context 'receive invalid parameters' do
      it 'returns failure' do
        expect(auth_contract.call(Hash.new).failure?).to eq(true)
      end

      it 'do not receive email' do
        expect(
          auth_contract.call(password: 'test').errors[:email][0]
        ).to eq("is missing")
      end

      it 'do not receive password' do
        expect(
          auth_contract.call(email: 'test@hi.com').errors[:password][0]
        ).to eq("is missing")
      end

      it 'receives an invalid email' do
        expect(
          auth_contract.call(email: 'test').errors[:email][0]
        ).to eq("must be a valid email - #{Message.info}")
      end
    end
  end
end
