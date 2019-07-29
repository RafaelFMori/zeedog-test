require 'rails_helper'

RSpec.describe Auth::AuthenticateOperation do

  let(:auth_params) { { email: 'foobar@gmail.com', password: 'foobar'} }
  let(:unauth_params) { { email: 'fuba@gmail.com', password: 'fuba'} }
  let(:failing_params) { { email: 'test', password: 1} }

  describe '#validate_contract' do
    before { User.create(auth_params) }

    context 'receives right parameters' do
      before do
        @context = {contract: Auth::AuthenticateContract.new.(auth_params)}
        @operation = Auth::AuthenticateOperation.new.validate_contract(@context)
      end

      it 'succeeds' do
        expect(@operation.success?).to eq(true)
      end
    end

    context 'receives wrong parameters' do
      before do
        @context = {contract: Auth::AuthenticateContract.new.(failing_params)}
        @operation = Auth::AuthenticateOperation.new.validate_contract(@context)
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
        @context = {contract: Auth::AuthenticateContract.new.({})}
        @operation = Auth::AuthenticateOperation.new.validate_contract(@context)
      end

      it 'fails' do
        expect(@operation.failure?).to eq(true)
      end

      it 'returns an invalid contract message' do
        expect(@operation.failure).to eq(:invalid_contract)
      end
    end
  end

  describe '#authenticate' do
    before { User.create(auth_params) }
    context 'sucessfully authenticate user' do
      before do
        @context = {contract: Auth::AuthenticateContract.new.(auth_params),
                    authenticator: AuthenticateUser}
        @operation = Auth::AuthenticateOperation.new.(@context)
      end
      it 'returns auth_token' do
        expect(@operation.success).to have_key(:auth_token)
      end
    end

    context 'cannot authenticate user' do
      before do
        @context = {contract: Auth::AuthenticateContract.new.(unauth_params),
                    authenticator: AuthenticateUser}
        @operation = Auth::AuthenticateOperation.new.(@context)
      end

      it 'returns no auth token' do
        expect(@context).to_not have_key(:auth_token)
      end

      it 'returns a unauthorized message' do
        expect(@operation.failure).to eq(:unauthorized)
      end
    end
  end
end
