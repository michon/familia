class ApplicationController < ActionController::Base
before_action :configure_permitted_parameters, if: :devise_controller?  

  
  # Asegurarse de que Devise esté configurado para usar :usuario en lugar de :user
  protect_from_forgery with: :exception
  before_action :authenticate_usuario!

def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_in) do |user_params|
    user_params.permit(:username, :email, :remember_me)
  end
end

end
