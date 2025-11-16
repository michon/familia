# app/controllers/seleccion_horarios_controller.rb
class SeleccionHorariosController < ApplicationController
  skip_before_action :authenticate_usuario!
  before_action :encontrar_usuario_por_token

  def edit
    @horarios = Horario.all.includes(:instructor, :aula).order(:diaSemana, :hora, :minuto)
    @selecciones_ids = Preinscripcion.where(usuario_id: @usuario.id, activo: true).pluck(:horario_id)
  end

  def update
    horario_ids = Array(params[:horario_ids]).map(&:to_i)

    Preinscripcion.transaction do
      # Desactivar todas las selecciones previas
      Preinscripcion.where(usuario_id: @usuario.id).update_all(activo: false)

      # Activar las nuevas selecciones
      horario_ids.each do |horario_id|
        preinscripcion = Preinscripcion.find_or_initialize_by(
          usuario_id: @usuario.id,
          horario_id: horario_id
        )
        preinscripcion.activo = true
        preinscripcion.save!
      end
    end

    redirect_to seleccion_horarios_path(token: @usuario.preinscripcion_token),
                notice: '¡Horarios seleccionados correctamente!'
  end

  private

  def encontrar_usuario_por_token
    @usuario = Usuario.find_by(preinscripcion_token: params[:token])
    if @usuario.nil?
      redirect_to root_path, alert: 'Enlace inválido o expirado'
    end
  end
end
