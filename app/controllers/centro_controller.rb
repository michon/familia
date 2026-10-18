class CentroController < ApplicationController
  # La serie de Yogasutras es pública: se desbloquea por fecha, no por login.
  skip_before_action :authenticate_usuario!, only: [:sutras, :sutra]

  # Clave de vista previa para instructores (solo lectura, se comparte por el
  # grupo interno). Cambiar aquí si hace falta rotarla.
  SUTRAS_PREVIEW_KEY = 'sutr4s-p4t4nj4l1'

  # Fechas de publicación de cada sutra (lunes y miércoles, 2 por semana).
  # Arranque: mié 14/10/2026 (1.1) y lun 19/10/2026 (1.2).
  # Fin de serie: mié 21/04/2027 (1.51).
  SUTRAS_FECHAS = {
  'sutra_1_1' => Date.new(2026, 10, 14),
  'sutra_1_2' => Date.new(2026, 10, 19),
  'sutra_1_3' => Date.new(2026, 10, 21),
  'sutra_1_4' => Date.new(2026, 10, 26),
  'sutra_1_5' => Date.new(2026, 10, 28),
  'sutra_1_6' => Date.new(2026, 11, 2),
  'sutra_1_7' => Date.new(2026, 11, 4),
  'sutra_1_8' => Date.new(2026, 11, 9),
  'sutra_1_9' => Date.new(2026, 11, 11),
  'sutra_1_10' => Date.new(2026, 11, 16),
  'sutra_1_11' => Date.new(2026, 11, 18),
  'sutra_1_12' => Date.new(2026, 11, 23),
  'sutra_1_13' => Date.new(2026, 11, 25),
  'sutra_1_14' => Date.new(2026, 11, 30),
  'sutra_1_15' => Date.new(2026, 12, 2),
  'sutra_1_16' => Date.new(2026, 12, 7),
  'sutra_1_17' => Date.new(2026, 12, 9),
  'sutra_1_18' => Date.new(2026, 12, 14),
  'sutra_1_19' => Date.new(2026, 12, 16),
  'sutra_1_20' => Date.new(2026, 12, 21),
  'sutra_1_21' => Date.new(2026, 12, 23),
  'sutra_1_22' => Date.new(2027, 1, 11),
  'sutra_1_23' => Date.new(2027, 1, 13),
  'sutra_1_24' => Date.new(2027, 1, 18),
  'sutra_1_25' => Date.new(2027, 1, 20),
  'sutra_1_26' => Date.new(2027, 1, 25),
  'sutra_1_27' => Date.new(2027, 1, 27),
  'sutra_1_28' => Date.new(2027, 2, 1),
  'sutra_1_29' => Date.new(2027, 2, 3),
  'sutra_1_30' => Date.new(2027, 2, 8),
  'sutra_1_31' => Date.new(2027, 2, 10),
  'sutra_1_32' => Date.new(2027, 2, 15),
  'sutra_1_33' => Date.new(2027, 2, 17),
  'sutra_1_34' => Date.new(2027, 2, 22),
  'sutra_1_35' => Date.new(2027, 2, 24),
  'sutra_1_36' => Date.new(2027, 3, 1),
  'sutra_1_37' => Date.new(2027, 3, 3),
  'sutra_1_38' => Date.new(2027, 3, 8),
  'sutra_1_39' => Date.new(2027, 3, 10),
  'sutra_1_40' => Date.new(2027, 3, 15),
  'sutra_1_41' => Date.new(2027, 3, 17),
  'sutra_1_42' => Date.new(2027, 3, 22),
  'sutra_1_43' => Date.new(2027, 3, 24),
  'sutra_1_44' => Date.new(2027, 3, 29),
  'sutra_1_45' => Date.new(2027, 3, 31),
  'sutra_1_46' => Date.new(2027, 4, 5),
  'sutra_1_47' => Date.new(2027, 4, 7),
  'sutra_1_48' => Date.new(2027, 4, 12),
  'sutra_1_49' => Date.new(2027, 4, 14),
  'sutra_1_50' => Date.new(2027, 4, 19),
  'sutra_1_51' => Date.new(2027, 4, 21),
  }.freeze

  def comienzo
    if current_usuario.blank?
      redirect_to  new_usuario_session_path
    else
      @usr = current_usuario
      @clases = ClaseAlumno.where(diaHora: Date.today.beginning_of_day.., usuario_id: @usr.id).order(:diaHora)
    end
  end

  def politica
  end

  def aviso
  end

  def cookies
  end

  def tutoriales; end
  def serie_basica_respiracion; end

  def sutras; end
  def sutra_1_1; end
  def sutra_1_2; end

  # Lección individual: /sutras/leccion/NUM  (p.ej. 1-3)
  # - Sin login y sin clave: solo visible a partir de su fecha de publicación.
  # - Con ?preview=CLAVE: visible siempre (para instructores).
  def sutra
    num = params[:num].to_s
    raise ActionController::RoutingError, 'No encontrado' unless num =~ /\A\d+-\d+\z/
    clave = "sutra_#{num.tr('-', '_')}"
    raise ActionController::RoutingError, 'No encontrado' unless SUTRAS_FECHAS.key?(clave)
    unless params[:preview] == SUTRAS_PREVIEW_KEY || Date.today >= SUTRAS_FECHAS[clave]
      raise ActionController::RoutingError, 'No publicado todavía'
    end
    render "centro/#{clave}"
  end
end
