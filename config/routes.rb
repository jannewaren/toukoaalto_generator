ToukoaaltoGenerator::Application.routes.draw do
      
  resources :photos

  root "pages#home"
  
  get "/home", to: "pages#home", as: "home"
  
end
