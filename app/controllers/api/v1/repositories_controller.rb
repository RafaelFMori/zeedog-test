module Api
  module V1
    class RepositoriesController < ApplicationController
      def list
        Repositories::ListOperation.new.(list_dependencies) do |op|
          op.success do |context|
            render json: context, status: 200
          end

          op.failure :validate_contract do |failure|
            contract = Repositories::ListContract.new.(params)
            render json: {code: 400, status: Message.bad_request, error: contract.errors}, status: 400
          end

          op.failure :list do |failure|
            render json: {code: 500, status: Message.internal_error, error: failure}, status: 500
          end
        end
      end

      def search
        Repositories::SearchOperation.new.(search_dependencies) do |op|
          op.success do |context|
            render json: context, status: 200
          end

          op.failure :validate_contract do |failure|
            contract = Repositories::SearchContract.new.(params)
            render json: {code: 400, status: Message.bad_request, error: contract.errors}, status: 400
          end

          op.failure :search do |failure|
            render json: {code: 500, status: Message.internal_error, error: failure}, status: 500
          end
        end
      end

      private
      def search_dependencies
        {
          contract: Repositories::SearchContract.new.(params)
        }
      end

      def list_dependencies
        {
          contract: Repositories::ListContract.new.(params)
        }
      end
    end
  end
end
