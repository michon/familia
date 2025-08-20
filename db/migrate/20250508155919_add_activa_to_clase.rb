class AddActivaToClase < ActiveRecord::Migration[7.1]
  def change
    add_column :clases, :activa, :boolean
  end
end
