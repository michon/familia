class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable
  belongs_to :grupoAlumno
  has_many :horarioAlumno
  has_many :recibos
  has_many :cajas
  has_one :instructor
  has_one_attached :image, :dependent => :destroy
  has_many :preinscripciones, class_name: 'Preinscripcion'

  scope :activo, -> {where(debaja: false, instructor_id: [0,nil])}
  scope :inactivos, -> {where(debaja: true)}
  default_scope { order(nombre: :asc) }

  enum rol: [:yogui, :instructor, :admin, :michon]

  after_initialize :set_default_rol, :if => :new_record?

  def set_default_rol
    sef_rol ||= :usuario
  end


  def self.ransackable_attributes(auth_object = nil)
    [ "nombre" ]
  end  

  def ibanImpreso
      ibanImp = ""
      (self.iban.length/4).times do |i|
        ibanImp <<  self.iban[(i*4)..(i*4)+3] + " "
      end
      ibanImp
  end

  def horarios_seleccionados
    Preinscripcion.where(usuario_id: id, activo: true).map(&:horario)
  end

  def generar_token_preinscripcion!
    self.preinscripcion_token ||= SecureRandom.urlsafe_base64(32)
    save!
  end

  # Devise ya debería crear este método automáticamente para el campo boolean 'admin'
  # Pero si no existe, añádelo:
  def admin?
    admin == true
  end
end
