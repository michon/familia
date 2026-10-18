# app/jobs/inscripcion_clase_mailer_job.rb
class InscripcionClaseMailerJob < ApplicationJob
  queue_as :default

  def perform(clase_alumno_id, usuario_id)
    begin
      clase_alumno = ClaseAlumno.find(clase_alumno_id)
      usuario = Usuario.find(usuario_id)

      VishnuMailer.inscripcionAlumno(clase_alumno, usuario).deliver_now
      Rails.logger.info "✅ Email de inscripción enviado al alumno: #{usuario.email}"

      VishnuMailer.inscripcion(clase_alumno, usuario).deliver_now
      Rails.logger.info "✅ Email de inscripción enviado al instructor"

    rescue => e
      Rails.logger.error "❌ Error en InscripcionClaseMailerJob: #{e.message}"
    end
  end
end

