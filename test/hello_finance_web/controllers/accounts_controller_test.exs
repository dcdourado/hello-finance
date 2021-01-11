defmodule HelloFinanceWeb.Controllers.AccountsControllerTest do
  use HelloFinanceWeb.ConnCase

  import HelloFinanceWeb.Auth.Guardian

  @create_attrs %{currency: "BRL", balance: 100}
  @invalid_attrs %{currency: nil, balance: nil}

  describe "create/2" do
    setup %{conn: conn} do
      params = %{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}
      {:ok, user} = HelloFinance.create_user(params)
      {:ok, token, _claims} = encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn}
    end

    test "when all params are valid, creates the account and returns 201", %{conn: conn} do
      conn = post(conn, Routes.accounts_path(conn, :create, @create_attrs))

      assert %{"message" => "Account created"} = json_response(conn, :created)
    end

    test "when params are invalid, returns 400", %{conn: conn} do
      conn = post(conn, Routes.accounts_path(conn, :create, @invalid_attrs))

      assert %{"errors" => errors} = json_response(conn, :bad_request)
    end
  end
end
