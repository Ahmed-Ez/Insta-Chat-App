Rails.application.routes.draw do
  get 'apps/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :apps do
    resources :chats do
      resources :messages do
        collection do
          get 'search'
        end
      end
    end
  end
end
