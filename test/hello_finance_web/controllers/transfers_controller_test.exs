defmodule HelloFinanceWeb.Controllers.TransfersControllerTest do
  use HelloFinanceWeb.ConnCase

  alias HelloFinance.{Repo, User}
  alias User.Account

  @create_attrs_no_accounts %{currency: "BRL", value: 100}
  @invalid_attrs %{currency: nil, value: nil, sender_account_id: nil, receiver_account_id: nil}
  @helper_user_attrs %{name: "Diogo", password: "123456", email: "dcdourado@gmail.com"}

  describe "create/2" do
    test "when all params are valid, creates the user and returns 201", %{conn: conn} do
      {:ok, user_struct} = User.build(@helper_user_attrs)
      {:ok, %User{id: user_id}} = Repo.insert(user_struct)

      account_params = %{currency: "BRL", balance: 1000, user_id: user_id}

      {:ok, account_struct} = Account.build(account_params)
      {:ok, %Account{id: sender_account_id}} = Repo.insert(account_struct)
      {:ok, %Account{id: receiver_account_id}} = Repo.insert(account_struct)

      params =
        Map.put(@create_attrs_no_accounts, :sender_account_id, sender_account_id)
        |> Map.put(:receiver_account_id, receiver_account_id)

      conn = post(conn, Routes.transfers_path(conn, :create, params))

      assert %{"message" => "Transfer created"} = json_response(conn, :created)
    end

    test "when params are invalid, returns 400", %{conn: conn} do
      conn = post(conn, Routes.transfers_path(conn, :create, @invalid_attrs))

      assert %{"errors" => errors} = json_response(conn, :bad_request)
    end
  end
end
