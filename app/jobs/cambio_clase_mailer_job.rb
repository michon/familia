# app/jobs/cambio_clase_mailer_job.rb
class CambioClaseMailerJob < ApplicationJob
  queue_as :default
  
  def perform(usuario_id, clase_origen_id, clase_destino_id, clase_alumno_id)
    begin
      usuario = Usuario.find(usuario_id)
      clase_origen = Clase.find(clase_origen_id)
      clase_destino = Clase.find(clase_destino_id)
      clase_alumno = ClaseAlumno.find(clase_alumno_id)
      
      # Email al alumno
      VishnuMailer.cambioAlumno(clase_origen, clase_alumno).deliver_now
      Rails.logger.info "✅ Email de cambio enviado al alumno: #{usuario.email}"
      
      # Email al instructor
      VishnuMailer.cambio(clase_origen, clase_alumno).deliver_now
      Rails.logger.info "✅ Email de cambio enviado al instructor"
      
    rescue => e
      Rails.logger.error "❌ Error en CambioClaseMailerJob: #{e.message}"
      # Puedes agregar notificaciones adicionales aquí si falla
    end
  end
end

