class AddAliasToUsuario < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :alias, :string
  end
end
