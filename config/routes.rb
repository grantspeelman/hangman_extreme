QuickApp::Application.routes.draw do
  mount V1::Api => '/'

  get "purchase_transactions", to: 'purchase_transactions#index', as: 'purchases'
  get "purchase_transactions/new", as: 'new_purchase'
  get "purchase_transactions/create", to: 'purchase_transactions#create', as: 'create_purchase'
  get "Transaction/PaymentRequest", to: 'purchase_transactions#simulate_purchase', as: 'mxit_purchase'
  get "explain/:action", as: 'explain', controller: 'explain'
  get "airtime_vouchers", to: 'airtime_vouchers#index', as: 'airtime_vouchers'

  resource :user_accounts, only: [:show, :edit, :update], path: 'profile' do
    get 'mxit_oauth', action: 'mxit_oauth', as: 'mxit_oauth'
  end
  resources :feedback, path: "user_comments", :except => [:show, :edit, :update, :destroy]
  resources :redeem_winnings, :except => [:edit, :update, :destroy]

  get '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/:provider/failure', to: 'sessions#failure'
  get '/auth/failure', to: 'sessions#failure'
  get '/authorize', to: 'user_accounts#mxit_authorise', as: 'mxit_authorise'
  get '/about', to: 'explain#about', as: 'about'
  get '/terms', to: 'explain#terms', as: 'terms'
  get '/privacy', to: 'explain#privacy', as: 'privacy'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  root :to => 'explain#about'
end
