Rails.application.routes.draw do

  devise_for :users, controllers: {
                       omniauth_callbacks: 'users/omniauth_callbacks',
                       registrations: 'users/registrations'
                   }

  get 'error_logs_controller/index'
  get 'error_logs_controller/show'
  get 'error_logs_controller/fix'
  get 'summary/index'
  get 'angular', :to => redirect('/angular')
  get 'angular/form', :to => redirect('/angular/form.html')
  get 'angular/reg', :to => redirect('/angular/reg.html')



  root 'stocks#index'
  get 'admin' => 'admin#index'
  #
  # controller :sessions do
  #   get  'login' => :new
  #   post 'login' => :create
  #   delete 'logout' => :destroy
  # end
  #
  # get "sessions/create"
  # get "sessions/destroy"

  resources :groups
  resources :users
  resources :stocks
  resources :runs

  post 'user/validate' => "users#validate_user"
  post 'run/activate' => "runs#activate"
  post 'run/finalize' => "runs#finalize"
  get 'stocks/run/:id' => "stocks#run"
  get 'summary/run/:id' => "summary#run"
  get 'summary' => "summary#overview"
  get "sessions/login" => "sessions#face_login"


end
