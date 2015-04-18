Rails.application.routes.draw do

  resources :emergencies, param: :name, defaults: { format: :json }
  resources :responders, param: :name, defaults: { format: :json }

end
