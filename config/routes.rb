Messenger::Application.routes.draw do
  resources :messages, :only => [:index, :create, :show], :format => :json

  root :to => 'home#index'
end
