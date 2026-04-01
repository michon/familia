# lib/tasks/limpiar_duplicados.rake
namespace :clase_alumnos do
  desc "Limpiar registros duplicados de clase_alumnos manteniendo los de mayor prioridad"
  task limpiar_duplicados: :environment do
    puts "Iniciando limpieza de duplicados..."
    
    # Paso 1: Convertir 'Viene' a 'Asistió' en clases pasadas
    puts "Convirtiendo 'Viene' a 'Asistió' en clases pasadas..."
    updated = ClaseAlumno.where(claseAlumnoEstado_id: 1)
                        .where("diaHora < ?", Time.current)
                        .update_all(claseAlumnoEstado_id: 2)
    puts "✅ Convertidos #{updated} registros"
    
    # Paso 2: Encontrar duplicados
    puts "Buscando duplicados..."
    duplicados_sql = <<-SQL
      SELECT usuario_id, clase_id, COUNT(*) as count
      FROM clase_alumnos 
      GROUP BY usuario_id, clase_id 
      HAVING COUNT(*) > 1
    SQL
    
    duplicados = ActiveRecord::Base.connection.execute(duplicados_sql).to_a
    puts "📊 Encontrados #{duplicados.size} grupos de duplicados"
    
    # Paso 3: Procesar cada grupo de duplicados
    duplicados.each_with_index do |duplicado, index|
      usuario_id = duplicado[0]
      clase_id = duplicado[1]
      
      puts "Procesando duplicado #{index + 1}/#{duplicados.size}: usuario #{usuario_id}, clase #{clase_id}"
      
      # Encontrar todos los registros duplicados para este usuario/clase
      registros = ClaseAlumno.where(usuario_id: usuario_id, clase_id: clase_id)
      
      # Determinar cuál mantener (mayor prioridad)
      registro_a_mantener = registros.max_by do |r|
        case r.claseAlumnoEstado_id
        when 2, 4 then 3  # Asistió/Faltó - máxima prioridad
        when 5 then 2     # Cambio
        when 3 then 1     # No viene
        when 1 then 0     # Viene
        else -1
        end
      end
      
      # Eliminar los otros registros
      registros.where.not(id: registro_a_mantener.id).destroy_all
      puts "  ✅ Mantenido registro #{registro_a_mantener.id} (estado: #{registro_a_mantener.claseAlumnoEstado_id})"
    end
    
    puts "🎉 Limpieza completada!"
  end

  desc "Agregar índice único a clase_alumnos"
  task agregar_indice: :environment do
    puts "Agregando índice único..."
    
    begin
      # Verificar si el índice ya existe
      existing_index = ActiveRecord::Base.connection.indexes(:clase_alumnos)
                                .find { |idx| idx.columns == ['usuario_id', 'clase_id'] }
      
      if existing_index
        puts "⚠️  El índice único ya existe: #{existing_index.name}"
      else
        # Crear el índice
        ActiveRecord::Base.connection.execute(
          "CREATE UNIQUE INDEX unique_usuario_clase ON clase_alumnos (usuario_id, clase_id)"
        )
        puts "✅ Índice único creado exitosamente"
      end
    rescue => e
      puts "❌ Error creando índice: #{e.message}"
    end
  end

  desc "Ejecutar limpieza completa"
  task limpieza_completa: :environment do
    Rake::Task['clase_alumnos:limpiar_duplicados'].invoke
    Rake::Task['clase_alumnos:agregar_indice'].invoke
  end
end
