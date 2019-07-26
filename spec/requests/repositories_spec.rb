require 'rails_helper'

RSpec.describe 'Repositories API',type: :request do

  let(:list_params) { { type: "public", page: 1, per_page: 5 } }
  let(:search_params) { { search_options: 'user:jekyll', page: 1,
                          per_page: 5, sort:'forks', order:'asc' } }

  describe 'GET /repositories/search' do
    context 'valid request' do
      before { get '/api/v1/repositories/search', params: search_params }
      it 'returns status code 200' do
       expect(response).to have_http_status(200)
      end
    end

    context 'invalid request' do
     before do
        get '/api/v1/repositories/search', params: { }
     end

     it 'returns status code 400' do
       expect(response).to have_http_status(400)
     end
    end
  end

  describe 'GET /repositories/list' do
    context 'valid request' do
      before { get '/api/v1/repositories/list', params: search_params }
      it 'returns status code 200' do
       expect(response).to have_http_status(200)
      end
    end

    context 'invalid request' do
     before do
        get '/api/v1/repositories/list', params: { type: 1 }
     end

     it 'returns status code 400' do
       expect(response).to have_http_status(400)
     end
   end
  end
end
