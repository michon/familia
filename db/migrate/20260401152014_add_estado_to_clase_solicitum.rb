# db/migrate/20260401170000_add_estado_to_clase_solicitum.rb
class AddEstadoToClaseSolicitum < ActiveRecord::Migration[7.0]
  def change
    add_column :clase_solicita, :estado, :string, default: 'pendiente', null: false
    add_column :clase_solicita, :reservado_hasta, :datetime
    add_column :clase_solicita, :token_confirmacion, :string
    
    add_index :clase_solicita, :estado
    add_index :clase_solicita, :token_confirmacion, unique: true
  end
end
