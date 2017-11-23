Rails.application.routes.draw do
  resources :publishers, only: [] do
    resources :shops, only: [:index], defaults: {format: :json}
  end

  resources :shops, only: [] do
    resources :books, only: [] do
      resources :sells, only: :create
    end
  end
end
