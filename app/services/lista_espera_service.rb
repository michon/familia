# app/services/lista_espera_service.rb
class ListaEsperaService
  TIEMPO_RESERVA_MINUTOS = 240 # 4 horas para confirmar

  def self.procesar_baja(clase)
    return unless plaza_disponible?(clase)

    # Obtener siguiente de la lista (más antiguo, pendiente)
    solicitud = clase.claseSolicitum.pendientes.por_antiguedad.first

    return unless solicitud

    # Reservar plaza temporalmente
    reservar_plaza(solicitud)

    # Enviar notificación
    NotificacionListaEsperaJob.perform_later(solicitud.id)
  end

  def self.confirmar_inscripcion(token)
    solicitud = ClaseSolicitum.find_by(token_confirmacion: token, estado: 'reservada')
    return false unless solicitud
    return false if solicitud.reserva_caducada?

    ActiveRecord::Base.transaction do
      # Crear inscripción definitiva
      ClaseAlumno.create!(
        clase: solicitud.clase,
        usuario: solicitud.usuario,
        claseAlumnoEstado_id: 1, # Viene
        diaHora: solicitud.clase.diaHora,
        instructor: solicitud.clase.instructor
      )

      # Actualizar solicitud
      solicitud.update!(estado: 'confirmada')

      # ELIMINAR la solicitud de la tabla (nueva línea)
      solicitud.destroy!

      # Notificar confirmación
      VishnuMailer.inscripcion_confirmada(solicitud).deliver_later
    end

    true
  rescue => e
    Rails.logger.error "Error confirmando inscripción: #{e.message}"
    false
  end

  def self.rechazar_inscripcion(token)
    solicitud = ClaseSolicitum.find_by(token_confirmacion: token)
    return false unless solicitud

    solicitud.update!(estado: 'caducada')

    # Procesar siguiente de la lista si hay plaza
    procesar_baja(solicitud.clase) if plaza_disponible?(solicitud.clase)

    true
  end

  def self.liberar_reservas_caducadas
    ClaseSolicitum.reservadas.find_each do |solicitud|
      next unless solicitud.reserva_caducada?

      solicitud.update!(estado: 'caducada')
      procesar_baja(solicitud.clase)
    end
  end

  private

  def self.plaza_disponible?(clase)
    ocupacion = clase.claseAlumno.where(claseAlumnoEstado_id: 1).count +
                clase.pruebas.count

    ocupacion < clase.aula.aforo
  end

  def self.reservar_plaza(solicitud)
    solicitud.generar_token!
    solicitud.update!(
      estado: 'reservada',
      reservado_hasta: TIEMPO_RESERVA_MINUTOS.minutes.from_now
    )
  end
end
