class VishnuMailer < ApplicationMailer
    default from: 'web@agarayoga.eu'

  def presentacion(usr)
    @url  = 'http://familia.agarayoga.eu/presentacion'
    mail(to: usr.email, subject: 'Hola. Soy Vishnu, el asistente virtual de AgâraYoga.')
  end

  def solicitudAlumno(clAl, usr)
    @clAl = clAl
    @url  = 'https://familia.agarayoga.eu/'
    mail(to: usr.email, subject: "Estás en la lista de espera para la clase #{@clAl.clase.clase_humano}")
  end

  def solicitud(clAl, usr)
    @clAl = clAl
    @url  = 'http://familia.agarayoga.eu/'
    mail(to: 'miguel.softgalia@gmail.com', subject: "#{usr.nombre} en lista de espera para la clase #{@clAl.clase.clase_humano}")
  end

  def inscripcionAlumno(clAl, usr)
    @clAl = clAl
    @url  = 'https://familia.agarayoga.eu/'
    mail(to: usr.email, subject: "Tu inscripción en la clase #{@clAl.clase.clase_humano} confirmada")
  end

  def inscripcion(clAl, usr)
    @clAl = clAl
    @url  = 'http://familia.agarayoga.eu/'
    mail(to: 'miguel.softgalia@gmail.com', subject: "#{usr.nombre} se ha inscrito en la clase #{@clAl.clase.clase_humano}")
  end

  def cambioAlumno(clOrigen, clDestino)
    @clOrigen = clOrigen
    @clDestino = clDestino
    @url  = 'http://familia.agarayoga.eu/cambio'
    mail(to: clDestino.usuario.email, subject: 'Confirmación de cambio de clase.')
  end

  def cambio(clOrigen, clDestino)
    @clOrigen = clOrigen
    @clDestino = clDestino
    @url  = 'http://familia.agarayoga.eu/cambio'
    mail(to: 'miguel.softgalia@gmail.com', subject: "#{@clDestino.usuario.nombre} ha cambiado la clase #{@clOrigen.clase_humano} por la de #{@clDestino.clase.clase_humano}.")
  end

  def plaza_disponible(solicitud)
    @solicitud = solicitud
    @usuario = solicitud.usuario
    @clase = solicitud.clase
    @tiempo_limite = solicitud.reservado_hasta.strftime('%H:%M del %d/%m/%Y')

    # URLs de confirmación (ajusta el host según tu configuración)
    @url_confirmar = Rails.application.routes.url_helpers.confirmar_plaza_url(
      token: solicitud.token_confirmacion,
      host: 'familia.agarayoga.eu'
    )
    @url_rechazar = Rails.application.routes.url_helpers.rechazar_plaza_url(
      token: solicitud.token_confirmacion,
      host: 'familia.agarayoga.eu'
    )

    mail(
      to: @usuario.email,
      subject: "¡Plaza disponible! Confirma tu asistencia a #{@clase.clase_humano}"
    )
  end

  def inscripcion_confirmada(solicitud)
    @solicitud = solicitud
    @usuario = solicitud.usuario
    @clase = solicitud.clase

    mail(
      to: @usuario.email,
      subject: "Inscripción confirmada: #{@clase.clase_humano}"
    )
  end
end
