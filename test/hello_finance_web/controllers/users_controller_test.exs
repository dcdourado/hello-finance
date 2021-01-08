defmodule HelloFinanceWeb.Controllers.UsersControllerTest do
  use HelloFinanceWeb.ConnCase

  @create_attrs %{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}
  @invalid_attrs %{name: nil, email: nil, passworD: nil}

  describe "create/2" do
    test "when all params are valid, creates the user and returns 201", %{conn: conn} do
      conn = post(conn, Routes.users_path(conn, :create, @create_attrs))

      assert %{"message" => "User created"} = json_response(conn, :created)
    end

    test "when params are invalid, returns 400", %{conn: conn} do
      conn = post(conn, Routes.users_path(conn, :create, @invalid_attrs))

      assert %{"errors" => errors} = json_response(conn, :bad_request)
    end
  end
end
