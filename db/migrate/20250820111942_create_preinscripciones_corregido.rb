# db/migrate/20250820111101_create_preinscripciones_corregido.rb
class CreatePreinscripcionesCorregido < ActiveRecord::Migration[7.1]
  def change
    # Primero verificar que la tabla no existe
    return if table_exists?(:preinscripciones)

    create_table :preinscripciones do |t|
      t.bigint :usuario_id, null: false
      t.bigint :horario_id, null: false
      t.boolean :activo, default: false

      t.timestamps
    end

    # Añadir índices y foreign keys después de crear la tabla
    add_index :preinscripciones, [:usuario_id, :horario_id], unique: true
  end
end
