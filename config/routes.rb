Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :repositories do
        get :search
        get :list
      end
    end
  end
end
