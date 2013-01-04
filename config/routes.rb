Messenger::Application.routes.draw do
  namespace :v1 do
    resources :users, :only => [:create, :show], :format => :json do
      post 'validate', :on => :collection
    end
    resources :messages, :only => [:index, :create, :show], :format => :json
    resource :session, :only => [:create, :show, :destroy], :format => :json
  end

  root :to => 'home#index'
end
