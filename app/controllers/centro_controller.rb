class CentroController < ApplicationController
  def comienzo
    if current_usuario.blank? 
      redirect_to  new_usuario_session_path
    else
      @usr = current_usuario
      @clases = ClaseAlumno.where(diaHora: Date.today.beginning_of_day.., usuario_id: @usr.id).order(:diaHora)
    end
  end

  def politica
  end

  def aviso
  end

  def cookies
  end


end
