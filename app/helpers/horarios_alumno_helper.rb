module HorariosAlumnoHelper
  def dia_semana_completo(dia_num)
    dias = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado']
    dias[dia_num.to_i] || 'Día no válido'
  end
  
  def formatear_hora(horario)
    "#{horario.hora.to_s.rjust(2, '0')}:#{horario.minuto.to_s.rjust(2, '0')}"
  end
end
