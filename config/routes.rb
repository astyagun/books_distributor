Rails.application.routes.draw do
  resources :publishers, only: [] do
    resources :shops, only: [:index], defaults: {format: :json}
  end
end
