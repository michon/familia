# db/migrate/20250820111100_add_preinscripcion_token_corregido.rb
class AddPreinscripcionTokenToUsuariosCorregido < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :preinscripcion_token, :string
  end
end
