# app/models/preinscripcion.rb
class Preinscripcion < ApplicationRecord
  # Validaciones
  validates :usuario_id, presence: true
  validates :horario_id, presence: true
  validates :usuario_id, uniqueness: { scope: :horario_id }
  
  # Scopes
  scope :activas, -> { where(activo: true) }
  scope :por_usuario, ->(usuario_id) { where(usuario_id: usuario_id) }
  
  # Métodos para simular asociaciones (ya que no hay FKs)
  def usuario
    Usuario.find_by(id: usuario_id)
  end
  
  def horario
    Horario.find_by(id: horario_id)
  end
  
  def self.horarios_seleccionados(usuario_id)
    where(usuario_id: usuario_id, activo: true).pluck(:horario_id)
  end
end
