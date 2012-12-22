Messenger::Application.routes.draw do
  namespace :v1 do
    resources :users,    :only => [:create, :show],         :format => :json
    resources :messages, :only => [:index, :create, :show], :format => :json
    resource  :session,  :only => [:create, :destroy],      :format => :json
  end

  root :to => 'home#index'
end
