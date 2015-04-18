Rails.application.routes.draw do

  resources :emergencies, except: :new, param: :code, defaults: { format: :json }
  resources :responders, param: :name, defaults: { format: :json }

end
