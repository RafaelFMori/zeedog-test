require 'rails_helper'

RSpec.describe Auth::AuthorizeApiRequest do

  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }
  subject(:request_obj) { AuthorizeApiRequest.new }

  describe '#call' do
    context 'when valid request' do
      it 'returns user object' do
        result = request_obj.call(header)
        expect(result).to be_instance_of(User)
      end
    end

    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect { request_obj.call({}) }
            .to raise_error(ExceptionHandler::MissingToken, 'Missing token')
        end
      end

      context 'when invalid token' do
        let(:header) { { 'Authorization' => JsonWebToken.encode(user_id: 12) } }

        it 'raises an InvalidToken error' do
          expect { request_obj.call(header) }
            .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context 'when token is expired' do
        let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }, Time.now.to_i - 10) } }

        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect { request_obj.call(header) }
            .to raise_error(
              ExceptionHandler::InvalidToken,
              /Signature has expired/
            )
        end
      end

      context 'fake token' do
        let(:header) { { 'Authorization' => 'foobar' } }

        it 'handles JWT::DecodeError' do
          expect { request_obj.call(header) }
            .to raise_error(
              ExceptionHandler::InvalidToken,
              /Not enough or too many segments/
            )
        end
      end
    end
  end
end
