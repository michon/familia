require "test_helper"

class ClasesControllerTest < ActionDispatch::IntegrationTest
  test "should get asignadas" do
    get clases_asignadas_url
    assert_response :success
  end

  test "should get buscar" do
    get clases_buscar_url
    assert_response :success
  end

  test "should get cambiar" do
    get clases_cambiar_url
    assert_response :success
  end

  test "should get listaEspera" do
    get clases_listaEspera_url
    assert_response :success
  end
end
