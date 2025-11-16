# app/controllers/admin/preinscripciones_dashboard_controller.rb
module Admin
  class PreinscripcionesDashboardController < ApplicationController
    before_action :authenticate_usuario!
    before_action :verificar_admin

    def index
      @usuarios = Usuario.activo.order(:nombre)
      @total_usuarios = @usuarios.count
      @usuarios_respondidos = Preinscripcion.select(:usuario_id).distinct.count
      @progreso = (@usuarios_respondidos.to_f / @total_usuarios * 100).round(1)
    end

    private

    def verificar_admin
      unless current_usuario.admin?  # ← Esto verifica el campo boolean 'admin'
        redirect_to root_path, alert: "No tienes permisos de administrador"
      end
    end
  end
end
