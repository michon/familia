class ClaseSolicitum < ApplicationRecord
  belongs_to :clase
  belongs_to :usuario

  # Estados posibles
  ESTADOS = %w[pendiente reservada confirmada caducada].freeze

  # Validaciones
  validates :estado, inclusion: { in: ESTADOS }
  validates :token_confirmacion, uniqueness: true, allow_nil: true

  # Scopes útiles
  scope :pendientes, -> { where(estado: 'pendiente') }
  scope :reservadas, -> { where(estado: 'reservada') }
  scope :confirmadas, -> { where(estado: 'confirmada') }
  scope :caducadas, -> { where(estado: 'caducada') }
  scope :activas, -> { where(estado: ['pendiente', 'reservada']) }
  scope :por_antiguedad, -> { order(:created_at) }

  # Métodos de instancia
  def reservada?
    estado == 'reservada'
  end

  def pendiente?
    estado == 'pendiente'
  end

  def confirmada?
    estado == 'confirmada'
  end

  def caducada?
    estado == 'caducada'
  end

  def reserva_caducada?
    reservada? && reservado_hasta < Time.current
  end

  def tiempo_restante_reserva
    return 0 unless reservada? && reservado_hasta
    [reservado_hasta - Time.current, 0].max
  end

  # Generar token único
  def generar_token!
    self.token_confirmacion = loop do
      token = SecureRandom.urlsafe_base64(32)
      break token unless self.class.exists?(token_confirmacion: token)
    end
  end
end
