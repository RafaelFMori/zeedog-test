require 'rails_helper'

RSpec.describe 'Authentication',type: :request do

  let(:auth_params) { { email: 'foo@bar.com', password: 'foobar' } }
  let(:not_auth_params) { { email: 'bar@foo.com', password: 'barfoo' } }

  describe 'POST /authentications/authenticate' do
    context 'on valid request' do
      before do
        User.create(auth_params)
        post '/api/v1/authentications/authenticate', params: auth_params
      end
      it 'returns status code 200' do
       expect(response).to have_http_status(200)
      end

      it 'returns an auth_token' do
        expect(response.body).to match(/auth_token/)
      end
    end

    context 'invalid request' do
     before do
       post '/api/v1/authentications/authenticate', params: { }
     end

     it 'returns status code 400' do
       expect(response).to have_http_status(400)
     end

     it 'do not return a auth token' do
       expect(response.body).to_not match(/auth_token/)
     end
    end

    context 'unauthorized' do
     before do
       post '/api/v1/authentications/authenticate', params: not_auth_params
     end

     it 'returns status code 401' do
       expect(response).to have_http_status(401)
     end

     it 'do not return a auth token' do
       expect(response.body).to_not match(/auth_token/)
     end
    end
  end
end
