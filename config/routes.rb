Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :debts, only: [:new, :create, :show]
  resources :debts do
    resources :build, controller: 'debts/build'
  end
  get 'payment_options/dashboard', to: 'payment_options#dashboard', as: :payment_options_dashboard
  resources :payment_options, only: [:new, :create, :update, :show, :delete]

  get 'payment_options/:id/choose', to: 'payment_options#choose', as: :payment_options_choose
  # chat method for openai
  # get 'chatgpt/chat', to: 'chatgpt#index', as: :chat
  # post 'chatgpt/chat', to: 'chatgpt#chat', as: :chatgpt_chat
end
