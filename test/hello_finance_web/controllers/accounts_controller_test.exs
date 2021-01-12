defmodule HelloFinanceWeb.Controllers.AccountsControllerTest do
  use HelloFinanceWeb.ConnCase

  import HelloFinanceWeb.Auth.Guardian

  @create_attrs %{code: "BRL", balance: 100}
  @invalid_attrs %{code: nil, balance: nil}
  @helper_user_attrs %{name: "Diogo", password: "123456", email: "dcdourado@gmail.com"}

  setup %{conn: conn} do
    {:ok, %{id: user_id} = user} = HelloFinance.create_user(@helper_user_attrs)
    {:ok, token, _claims} = encode_and_sign(user)

    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    {:ok, conn: conn, user_id: user_id}
  end

  describe "create/2" do
    test "when all params are valid, creates the account and returns 201", %{conn: conn} do
      conn = post(conn, Routes.accounts_path(conn, :create, @create_attrs))

      assert %{"message" => "Account created"} = json_response(conn, :created)
    end

    test "when params are invalid, returns 400", %{conn: conn} do
      conn = post(conn, Routes.accounts_path(conn, :create, @invalid_attrs))

      assert %{"errors" => errors} = json_response(conn, :bad_request)
    end
  end

  describe "index/2" do
    test "when called, returns user accounts and 200", %{conn: conn} do
      conn = get(conn, Routes.accounts_path(conn, :index))

      assert %{"message" => "Accounts fetched"} = json_response(conn, :ok)
    end
  end

  describe "show/2" do
    test "when user owns the account, returns it and status 200", %{conn: conn, user_id: user_id} do
      params = Map.put(@create_attrs, :user_id, user_id)
      {:ok, %{id: account_id}} = HelloFinance.create_account(params)

      conn = get(conn, Routes.accounts_path(conn, :show, account_id))

      assert %{"message" => "Account fetched"} = json_response(conn, :ok)
    end
  end
end
