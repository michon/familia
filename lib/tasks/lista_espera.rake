# lib/tasks/lista_espera.rake
namespace :lista_espera do
  desc "Liberar reservas caducadas y procesar siguiente de la lista"
  task liberar_caducadas: :environment do
    Rails.logger.info "🔄 Iniciando liberación de reservas caducadas..."
    
    contador = 0
    ClaseSolicitum.reservadas.find_each do |solicitud|
      next unless solicitud.reserva_caducada?
      
      Rails.logger.info "⏰ Reserva caducada: solicitud #{solicitud.id}, usuario #{solicitud.usuario_id}"
      
      solicitud.update!(estado: 'caducada')
      ListaEsperaService.procesar_baja(solicitud.clase)
      contador += 1
    end
    
    Rails.logger.info "✅ Liberación completada. #{contador} reservas procesadas."
  end
end
