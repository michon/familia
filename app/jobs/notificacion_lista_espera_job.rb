# app/jobs/notificacion_lista_espera_job.rb
class NotificacionListaEsperaJob < ApplicationJob
  queue_as :default

  def perform(solicitud_id)
    solicitud = ClaseSolicitum.find(solicitud_id)
    
    # Verificar que sigue estando reservada (no caducó antes de procesar)
    return unless solicitud.reservada?

    # Enviar email con enlace de confirmación
    VishnuMailer.plaza_disponible(solicitud).deliver_now
    
    Rails.logger.info "📧 Notificación de plaza enviada a #{solicitud.usuario.email} para clase #{solicitud.clase_id}"
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "❌ Solicitud #{solicitud_id} no encontrada: #{e.message}"
  rescue => e
    Rails.logger.error "❌ Error en NotificacionListaEsperaJob: #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
  end
end
