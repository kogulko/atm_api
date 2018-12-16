Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  constraints format: :json do
    post '/atm/add', to: 'atm#replenish'
    post '/atm/withdraw', to: 'atm#withdraw'
  end
end
