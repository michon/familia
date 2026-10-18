# app/jobs/solicitud_clase_mailer_job.rb
class SolicitudClaseMailerJob < ApplicationJob
  queue_as :default

  def perform(solicitud_id, usuario_id)
    begin
      solicitud = ClaseSolicitum.find(solicitud_id)
      usuario = Usuario.find(usuario_id)

      VishnuMailer.solicitudAlumno(solicitud, usuario).deliver_now
      Rails.logger.info "✅ Email de solicitud enviado al alumno: #{usuario.email}"

      VishnuMailer.solicitud(solicitud, usuario).deliver_now
      Rails.logger.info "✅ Email de solicitud enviado al instructor"

    rescue => e
      Rails.logger.error "❌ Error en SolicitudClaseMailerJob: #{e.message}"
    end
  end
end


