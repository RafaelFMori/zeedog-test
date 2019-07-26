Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :repositories do
        get :search
        get :list
      end
      resource :authentications do
        post :authenticate
      end
    end
  end
end
