Rails.application.routes.draw do


  get 'welcome/index'
  post 'welcome/update'
  root 'welcome#index'
  get '/good'=> 'welcome#good'
  get '/bad' => 'welcome#bad'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
