# app/models/clase_alumno.rb
class ClaseAlumno < ApplicationRecord
  belongs_to :clase
  belongs_to :usuario
  belongs_to :instructor
  belongs_to :claseAlumnoEstado

  # Callbacks para detectar bajas y liberaciones de plaza
  after_destroy :procesar_lista_espera_si_habia_lista
  after_update :procesar_lista_espera_si_cambio_a_baja

  scope :futuras, -> { where('clase_alumnos.diaHora >= ?', DateTime.now) }
  scope :activas_por_usuario, ->(usuario_id) {
    where(usuario_id: usuario_id, claseAlumnoEstado_id: 1)
  }

  private

  # Se ejecuta al eliminar un alumno de la clase (destroy)
  def procesar_lista_espera_si_habia_lista
    # Solo procesar si hay lista de espera para esta clase
    return unless clase.claseSolicitum.activas.exists?

    ListaEsperaService.procesar_baja(clase)
  end

  # Se ejecuta al cambiar el estado (update)
  def procesar_lista_espera_si_cambio_a_baja
    # Verificar si cambió el estado Y el nuevo estado libera plaza
    # Estados que liberan plaza: 3 (No viene - avisó), 4 (Faltó), 5 (Cambio)
    estados_que_liberan = [3, 4, 5]

    return unless saved_change_to_claseAlumnoEstado_id
    return unless estados_que_liberan.include?(claseAlumnoEstado_id)
    return unless clase.claseSolicitum.activas.exists?

    ListaEsperaService.procesar_baja(clase)
  end
end
