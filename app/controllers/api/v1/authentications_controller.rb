module Api
  module V1
    class AuthenticationsController < ApplicationController
      skip_before_action :authenticate_request

      def authenticate
        Auth::AuthenticateOperation.new.(auth_dependencies) do |op|
          op.success do |context|
            render json: context, status: 200
          end

          op.failure :validate_contract do |failure|
            contract = Auth::AuthenticateContract.new.(params)
            render json: {code: 400, status: Message.bad_request, error: contract.errors}, status: 400
          end

          op.failure :authenticate do |failure|
            render json: {code: 401, status: Message.unauthorized, error: failure}, status: 401
          end
        end
      end

      private

      def auth_dependencies
        {
            contract: Auth::AuthenticateContract.new.(params),
            authenticator: AuthenticateUser
        }
      end
    end
  end
end
