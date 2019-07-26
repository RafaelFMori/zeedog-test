class ApplicationController < ActionController::API

before_action :params

  def params
    super.permit!.to_h
  end
end
