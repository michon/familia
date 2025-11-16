class ClasesController < ApplicationController
  before_action :usuario_autenticado  

  def historial
    @clases = ClaseAlumno.where(diaHora: DateTime.now-1.month..DateTime.now, usuario_id: current_usuario.id).order(:diaHora)
    @iconos = ['','calendar-clock','user-round-check','user-x','user-round-minus']
  end

  def asignadas
      @usr = current_usuario
      @clases = ClaseAlumno.where(diaHora: DateTime.now.., usuario_id: current_usuario.id, claseAlumnoEstado_id: 1).order(:diaHora)
      @solicitudes = ClaseSolicitum.where(usuario_id: current_usuario.id)
  end

  # buscarPost
  def buscarPost
    # Comprobaciones previas
    # 1. No está ya en la clase.
    # 2. Tiene clases por recuperar
    # 3. Existe el parametro clase destino
  #º
    # Añadir a la clase si hay hueco en la misma o
    # añadir a solicitudes si la clase ya está llena.

    # 0. Que exista la claseDestino
    unless ClaseAlumno.exists?(usuario_id: current_usuario.id, clase_id: params[:claseDestino])
      # En la clase a la que quiere acceder, no está inscrito
      begin

        cl = Clase.find(params[:claseDestino])

        # Si la clase está completa no entra en solicitud
        if cl.completo? 
          flash[:alert] = 'Solicitud recibida. Te avisaremos si hay plazas libres.'
          clAl = ClaseSolicitum.new(usuario_id: current_usuario.id, clase_id: cl.id)
          clAl.save
          VishnuMailer.solicitudAlumno(clAl, current_usuario).deliver
          VishnuMailer.solicitud(clAl, current_usuario).deliver
          flash[:alert] = "Hemos apuntado tu solucitud. Si queda alguna plaza, te avisaremos."
        else
          # si no está completa, entra se inscribe en la clase.
          clAl = cl.claseAlumno.new(usuario_id: current_usuario.id, claseAlumnoEstado_id: 1, diaHora: cl.diaHora, instructor_id: cl.instructor.id)
          clAl.save
          flash[:notice] = "¡Listo! Ya estás inscrito en la clase del " + clAl.clase.clase_humano
          VishnuMailer.inscripcionAlumno(clAl, current_usuario).deliver
          VishnuMailer.inscripcion(clAl, current_usuario).deliver
          flash[:alert] = "Has sido inscrito en la clase solicitada."
        end
        
        redirect_to clases_asignadas_path
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Selecciona una clase  "
        redirect_to :action => 'buscar'
      end
    end
  end

  # buscar 
  def buscar
    @clasesCreadas = Clase.where(diaHora: DateTime.now..).order(:diaHora)
    @clasesLibres = []
    @clasesCompletas = []
    @instructores = Instructor.where(id: @clasesCreadas.pluck(:instructor_id).uniq)
    @clasesCreadas.each do |cl|
      # Si ya está inscrito en alguna clase de ese día con el estado de Vendr con el estado de Vendrá, ya no puede ir a otra clase ese mismo día.
      if ClaseAlumno.where(usuario_id: current_usuario.id, claseAlumnoEstado_id: 1, diaHora: cl.diaHora.beginning_of_day..cl.diaHora.end_of_day).blank?
        if cl.completo? 
          @clasesCompletas << cl
        else
          @clasesLibres << cl
        end
      end
    end
  end

  def cambiarPost
    # igual debería controlar la excepción de que la clase no exita, aún que parezca imposible
    begin
      cl = Clase.find(params[:claseOrigen])
      clDestino = Clase.find(params[:claseDestino])

      #Buscamos al Alumno en la clase Origen
      clAl = ClaseAlumno.find_by(clase_id: params[:claseOrigen], usuario_id: current_usuario.id)
      #hacemos un copia
      clnuevo = clAl.dup
      clnuevo.clase_id = params[:claseDestino]
      clnuevo.instructor_id = clDestino.instructor_id
      clnuevo.diaHora = clDestino.diaHora
      clnuevo.claseAlumnoEstado_id = 1

      # Si no se puede grabar, lo introduccimos como solicitud
      unless clnuevo.save
        VishnuMailer.solicitudAlumno(clAl, current_usuario).deliver
        VishnuMailer.solicitud(clAl, current_usuario).deliver
        flash[:alert] = "Selecciona una clase destino "
        redirect_to :action => 'cambiar', id: 0
      else  # grabamos al alumno en la clas nueva y cambiams el estado de la anterior
        clAl.update(claseAlumnoEstado_id: 5)
        VishnuMailer.cambioAlumno(cl, clnuevo).deliver
        VishnuMailer.cambio(cl, clnuevo).deliver
        redirect_to clases_asignadas_path
      end

    rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Selecciona una clase origen  "
        redirect_to :action => 'cambiar', id: 0
    end
  end

  # cambiar
  def cambiar
    if params[:id] == '0'
        @claseOrigen = Clase.con_clase_alumno_activa(current_usuario.id)
                        .order('clase_alumnos.diaHora ASC')
                        .distinct
    else
      @claseOrigen = Clase.where(id: params[:id])
    end

    # sólo las clases que no están completas.
    @clasesCreadas = Clase.futuras.activas
                        .includes(:instructor, :aula)
                        .order(:diaHora)
  end

  def listaEspera
    @solicitudes = ClaseSolicitum.where(usuario_id: current_usuario.id)
    if @solicitudes.blank?
      flash[:alert] = 'No existen solicitudes en este momento'
    end
  end

  # AnularLista
  def anularLista
    slct = ClaseSolicitum.find(params[:id])
    flash[:notice] = "La solicitud ha para la clase #{slct.clase.clase_humano} sido eliminada"
    slct.destroy
    redirect_to root_path
  end

  # Anulaa ClaseAlumno
  def anular
    cl = ClaseAlumno.find(params[:id])
    cl.update(claseAlumnoEstado_id: 3)
    flash[:notice] = "Plaza liberada ✅ <br/> <br/>Gracias por avisar. Has sido dado de baja de la clase del #{cl.clase.clase_humano_instructor}."
    redirect_to clases_asignadas_path
  end

  def asistire
    clAl = ClaseAlumno.find(params[:id])
    # si la clase está completa, no puede inscriberse, lo apuntamos en solicitud de clase
    if clAl.clase.completo?
      flash[:alert] = 'La clase ya estaba completa. Has sido apuntado en la lista de espera. Te avisaremos si hay plazas libres.'
      ClaseSolicitum.new(usuario_id: current_usuario.id, clase_id: clAl.clase.id).save
    else
        # si no está completa, entra se inscribe en la clase.
      ClaseAlumno.find(params[:id]).update(claseAlumnoEstado_id: 1)
      flash[:notice] = "¡Listo! Ya estás inscrito en la clase del " + clAl.clase.clase_humano
    end

    redirect_to clases_asignadas_path
  end

  private
  def usuario_autenticado 
    unless usuario_signed_in?
      redirect_to root_path()
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:claseOrigen, :claseDestino)
  end
end
