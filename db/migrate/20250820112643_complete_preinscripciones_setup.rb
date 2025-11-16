# db/migrate/20250820113000_complete_preinscripciones_setup.rb
class CompletePreinscripcionesSetup < ActiveRecord::Migration[7.1]
  def change
    # 1. Asegurar que la columna token existe (pero no duplicar)
    unless column_exists?(:usuarios, :preinscripcion_token)
      add_column :usuarios, :preinscripcion_token, :string
      puts "✅ Columna preinscripcion_token añadida"
    else
      puts "⚠️  Columna preinscripcion_token ya existe"
    end

    # 2. Crear tabla preinscripciones si no existe
    unless table_exists?(:preinscripciones)
      create_table :preinscripciones do |t|
        t.bigint :usuario_id, null: false
        t.bigint :horario_id, null: false
        t.boolean :activo, default: false

        t.timestamps
      end
      puts "✅ Tabla preinscripciones creada"
    else
      puts "⚠️  Tabla preinscripciones ya existe"
    end

    # 3. Añadir índice único si la tabla existe
    if table_exists?(:preinscripciones) && !index_exists?(:preinscripciones, [:usuario_id, :horario_id])
      add_index :preinscripciones, [:usuario_id, :horario_id], unique: true
      puts "✅ Índice único añadido"
    end

    # 4. Añadir foreign keys si la tabla existe y no tienen FKs
    if table_exists?(:preinscripciones)
      begin
        add_foreign_key :preinscripciones, :usuarios, column: :usuario_id unless foreign_key_exists?(:preinscripciones, :usuarios)
        add_foreign_key :preinscripciones, :horarios, column: :horario_id unless foreign_key_exists?(:preinscripciones, :horarios)
        puts "✅ Foreign keys añadidas"
      rescue => e
        puts "⚠️  Error con foreign keys: #{e.message}"
      end
    end
  end
end
