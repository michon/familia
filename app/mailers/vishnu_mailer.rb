class VishnuMailer < ApplicationMailer
    default from: 'web@agarayoga.eu'

  def presentacion()
    @url  = 'http://agarayoga.eu/presentacion'
    mail(to: 'miguel.softgalia@gmail.com', subject: 'Hola. Soy Vishnu, el asistente virtual de AgâraYoga.')
  end
end
