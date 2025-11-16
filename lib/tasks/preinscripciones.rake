# lib/tasks/preinscripciones.rake
namespace :preinscripciones do
  desc "Generar tokens de preinscripción para todos los usuarios activos"
  task generar_tokens: :environment do
    usuarios = Usuario.activo
    puts "Generando tokens para #{usuarios.count} usuarios..."

    usuarios.each do |usuario|
      usuario.generar_token_preinscripcion!
      puts "✅ #{usuario.nombre}: #{usuario.preinscripcion_token}"
    end

    puts "Tokens generados exitosamente"
  end
end
