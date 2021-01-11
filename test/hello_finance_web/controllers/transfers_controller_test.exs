defmodule HelloFinanceWeb.Controllers.TransfersControllerTest do
  use HelloFinanceWeb.ConnCase

  import HelloFinanceWeb.Auth.Guardian

  alias HelloFinance.{Repo, User}
  alias User.Account

  @create_attrs_no_accounts %{value: 100}
  @invalid_attrs %{value: nil, from: nil, to: nil}
  @helper_user_attrs %{name: "Diogo", password: "123456", email: "dcdourado@gmail.com"}

  describe "create/2" do
    setup %{conn: conn} do
      {:ok, %{id: user_id} = user} = HelloFinance.create_user(@helper_user_attrs)
      {:ok, token, _claims} = encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn, user_id: user_id}
    end

    test "when all params are valid, creates the transfer and returns 201", %{
      conn: conn,
      user_id: user_id
    } do
      account_params = %{currency: "BRL", balance: 1000, user_id: user_id}

      {:ok, account_struct} = Account.build(account_params)
      {:ok, %Account{id: from}} = Repo.insert(account_struct)
      {:ok, %Account{id: to}} = Repo.insert(account_struct)

      params = Map.put(@create_attrs_no_accounts, :to, to)

      conn = post(conn, Routes.transfers_path(conn, :create, from, params))

      assert %{"message" => "Transfer created"} = json_response(conn, :created)
    end

    test "when params are invalid, returns 400", %{conn: conn} do
      conn = post(conn, Routes.transfers_path(conn, :create, 1, @invalid_attrs))

      assert %{"errors" => errors} = json_response(conn, :bad_request)
    end
  end
end
