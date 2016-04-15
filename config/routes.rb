PaddleSportsNorthAmerica::Application.routes.draw do

  get "coaches/index"

  root :to => "home#landing"

  get 'home' => "home#index"
  get 'about' => "home#about"

  get 'calendar' => "calendar#index", as: :calendar

  #get 'coaches' => "home#paddlers"
  get 'coaches' => "coaches#index"
  get 'documents' => "home#coaches"
  get 'membership' => "home#membership"

  get 'about/candidates' => "home#candidates"

  get 'contact' => "contact#index"
  post 'contact' => "contact#index"
  get 'contact/thank-you' => "contact#thank_you"

  # Active Admin has poor support for polymorphic relationships
  # so we have to declare our routes manually

  namespace :admin do
    get 'members/autocomplete' => 'members#autocomplete'
    # get '', to: 'dashboard#index', as: '/'
    resources :members do
      resources :addresses
      resources :phone_numbers
      resources :email_addresses

      resources :memberships do
        get 'print' => 'memberships#print'
      end

      resources :qualifications do
        get 'print' => 'qualifications#print'
      end

    end

    resources :centers do
      resources :addresses
      resources :phone_numbers
      resources :email_addresses
    end

    get 'products/autocomplete' => 'products#autocomplete'
  end

  # begin
    ActiveAdmin.routes(self)
  # rescue
    # Rails.logger.warn "Failed to initialize aa routes"
  # end

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :members
end
