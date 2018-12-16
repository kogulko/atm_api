Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/atm/add', to: 'banknotes#add'
  post '/atm/withdraw', to: 'banknotes#withdraw'
end
