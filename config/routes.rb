Messenger::Application.routes.draw do
  resources :messages, :only => [:index, :create, :show]
end
