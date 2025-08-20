class UsuariosController < ApplicationController
  def new
  end

  def create
  end

  def update
  end

  def edit
    @usr = current_usuario
  end

  def destroy
  end

  def index
  end

  def show
    @usr = current_usuario
  end
end
