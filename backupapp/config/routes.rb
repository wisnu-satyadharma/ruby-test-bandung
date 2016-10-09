Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :profiles do
  	member do
  		post :backup_now
  	end
  end

  get 'home/index'
  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
