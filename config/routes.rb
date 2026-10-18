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

  get '/confirmar-plaza', to: 'clases#confirmar_plaza', as: :confirmar_plaza
  get '/rechazar-plaza', to: 'clases#rechazar_plaza', as: :rechazar_plaza

  # Rutas para horario habitual.
  get 'mi-horario', to: 'horarios_alumno#index', as: :mi_horario


  get 'seleccion-horarios/:token', to: 'seleccion_horarios#edit', as: :seleccion_horarios
  patch 'seleccion-horarios/:token', to: 'seleccion_horarios#update'

  resource :usuario
  devise_for :usuarios

  get 'centro/comienzo'
  get 'centro/politica'
  get 'centro/aviso'
  get 'centro/cookies'
  get 'centro/bandhas'
  get 'sutras',       to: 'centro#sutras',       as: :centro_sutras
  get 'sutras/1-1', to: 'centro#sutra', defaults: { num: '1-1' }, as: :centro_sutra_1_1
  get 'sutras/1-2', to: 'centro#sutra', defaults: { num: '1-2' }, as: :centro_sutra_1_2
  get 'sutras/leccion/:num', to: 'centro#sutra', as: :centro_sutra, constraints: { num: /[0-9]+-[0-9]+/ }

  get 'tutoriales',                 to: 'centro#tutoriales',                 as: :centro_tutoriales
  get 'serie_basica_respiracion',   to: 'centro#serie_basica_respiracion',   as: :centro_serie_basica_respiracion



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
