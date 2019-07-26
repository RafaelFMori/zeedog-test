require 'rails_helper'

RSpec.describe 'Authentication',type: :request do

  let(:auth_params) { { email: 'foo@bar.com', password: 'foobar' } }

  describe 'POST /authentications/authenticate' do
    context 'valid request' do
      before do
        User.create(auth_params)
        post '/api/v1/authentications/authenticate', params: auth_params
      end
      it 'returns status code 200' do
       expect(response).to have_http_status(200)
      end
    end

    context 'invalid request' do
     before { post '/api/v1/authentications/authenticate', params: { } }

     it 'returns status code 400' do
       expect(response).to have_http_status(400)
     end
    end
  end
end
