Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :payment, only: [] do
    get 'payment_history'
    post 'payment_request'
  end
end
