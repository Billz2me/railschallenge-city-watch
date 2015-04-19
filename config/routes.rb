Rails.application.routes.draw do
  resources :emergencies,
            except: [:new, :edit, :destroy],
            param: :code,
            defaults: { format: :json }

  resources :responders,
            except: [:new, :edit, :destroy],
            param: :name,
            defaults: { format: :json }

  match '*path', to: 'errors#nonexistent_route', via: :all
end
