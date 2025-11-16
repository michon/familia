Rails.application.routes.draw do
  get  'clases/asignadas'
  get  'clases/buscar'
  get  'clases/historial'
  post 'clases/buscar',         to: 'clases#buscarPost',     as: 'clases/buscarPost/'
  get  'clases/cambiar/:id',    to: 'clases#cambiar',        as: 'clases/cambiar/'
  post 'clases/cambiar',        to: 'clases#cambiarPost',    as: 'clases/cambiarPost/'
  get  'clases/listaEspera'
  get  'clases/anularLista/:id',to: 'clases#anularLista',    as: 'clases/anularLista/'
  get  'clases/anular/:id',     to: 'clases#anular',         as: 'clases/anular/'
  get  'clases/asistire/:id',   to: 'clases#asistire',       as: 'clases/asistire/'

  # config/routes.rb
  get 'seleccion-horarios/:token', to: 'seleccion_horarios#edit', as: :seleccion_horarios
  patch 'seleccion-horarios/:token', to: 'seleccion_horarios#update'

  resource :usuario
  devise_for :usuarios

  get 'centro/comienzo'
  get 'centro/politica'
  get 'centro/aviso'
  get 'centro/cookies'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # config/routes.rb
  namespace :admin do
    get 'preinscripciones', to: 'preinscripciones_dashboard#index'
  end
  # Defines the root path route ("/")
   root "centro#comienzo"


end
