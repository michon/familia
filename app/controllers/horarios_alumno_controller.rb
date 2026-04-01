class HorariosAlumnoController < ApplicationController
  before_action :authenticate_usuario!
  before_action :set_usuario

  def index
    # Obtener los horarios habituales del alumno actual a través de horarioAlumno
    @horarios_alumno = @usuario.horarios
                               .includes(:instructor, :aula)
                               .order(:diaSemana, :hora, :minuto)

    # Agrupar por día para el badge de resumen
    @total_clases = @horarios_alumno.count
  end

  private

  def set_usuario
    @usuario = current_usuario
  end
end
