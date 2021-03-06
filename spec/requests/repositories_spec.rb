require 'rails_helper'

RSpec.describe 'Repositories API',type: :request do

  let(:list_params) { { type: "public", page: 1, per_page: 5 } }
  let(:search_params) { { label:'ruby', page: 1, per_page: 5,
                          sort:'forks', order:'asc' } }
  let(:not_found_search_params) { { username:'ydvjasdasu', page: 1, per_page: 5,
                                    sort:'forks', order:'asc' } }
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }

  describe 'GET /repositories/search' do
    context 'valid request' do
      before do
        get '/api/v1/repositories/search',
        params: search_params,
        headers: header
      end

      it 'returns status code 200' do
       expect(response).to have_http_status(200)
      end
    end

    context 'no repositories found' do
      before do
        get '/api/v1/repositories/search',
        params: not_found_search_params ,
        headers: header
      end
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'invalid request' do
     before do
        get '/api/v1/repositories/search',
        params: { },
        headers: header
     end

     it 'returns status code 400' do
       expect(response).to have_http_status(400)
     end
    end
  end

  describe 'GET /repositories/list' do
    context 'valid request' do
      before do
        get '/api/v1/repositories/list',
        params: search_params,
        headers: header
      end
      it 'returns status code 200' do
       expect(response).to have_http_status(200)
      end
    end

    context 'no repositories found' do
      before do
        get '/api/v1/repositories/search',
        params: not_found_search_params,
        headers: header
      end
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'invalid request' do
     before do
        get '/api/v1/repositories/list',
        params: { type: 1 },
        headers: header
     end

     it 'returns status code 400' do
       expect(response).to have_http_status(400)
     end
   end
  end
end
