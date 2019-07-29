class ApplicationController < ActionController::API

before_action :params, :authenticate_request


  private

  def params
    super.permit!.to_h
  end

  def authenticate_request
    AuthorizeApiRequest.new.(request.headers)
  end
end
