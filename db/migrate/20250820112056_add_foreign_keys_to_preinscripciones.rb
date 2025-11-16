# db/migrate/20250820111102_add_foreign_keys_to_preinscripciones.rb
class AddForeignKeysToPreinscripciones < ActiveRecord::Migration[7.1]
  def change
    # Añadir foreign keys por separado para evitar problemas
    add_foreign_key :preinscripciones, :usuarios, column: :usuario_id
    add_foreign_key :preinscripciones, :horarios, column: :horario_id
  end
end
