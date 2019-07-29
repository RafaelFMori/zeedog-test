require 'rails_helper'

RSpec.describe AuthenticateUser do
  let(:user) { create(:user) }
  subject(:valid_auth_obj) { described_class.new }
  subject(:invalid_auth_obj) { described_class.new }

  describe '#call' do

    context 'when valid credentials' do
      it 'returns an auth token' do
        token = valid_auth_obj.call(user.email, user.password)
        expect(token).not_to be_nil
      end
    end


    context 'when invalid credentials' do
      it 'do not returns an auth token' do
        token = invalid_auth_obj.call('foo', 'bar')
        expect(token).to be_nil
      end
    end
  end
end
