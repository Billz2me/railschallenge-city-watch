Rails.application.routes.draw do

  resources :emergencies, param: :code, defaults: { format: :json }
  resources :responders, param: :name, defaults: { format: :json }

end
