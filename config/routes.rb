Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
      resources :reservations, only: [] do
        collection do
          post :create_update
        end
      end
    end
  end
end
