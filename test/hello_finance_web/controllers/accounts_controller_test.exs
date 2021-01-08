defmodule HelloFinanceWeb.Controllers.AccountsControllerTest do
  use HelloFinanceWeb.ConnCase

  alias HelloFinance.{Repo, User}

  @create_attrs_no_user %{currency: "BRL", balance: 100}
  @invalid_attrs %{currency: nil, balance: nil, user_id: nil}
  @helper_user_attrs %{name: "Diogo", password: "123456", email: "dcdourado@gmail.com"}

  describe "create/2" do
    test "when all params are valid, creates the user and returns 201", %{conn: conn} do
      {:ok, user_struct} = User.build(@helper_user_attrs)
      {:ok, user} = Repo.insert(user_struct)

      %User{id: user_id} = user

      params = Map.put(@create_attrs_no_user, :user_id, user_id)
      conn = post(conn, Routes.accounts_path(conn, :create, params))

      assert %{"message" => "Account created"} = json_response(conn, :created)
    end

    test "when params are invalid, returns 400", %{conn: conn} do
      conn = post(conn, Routes.accounts_path(conn, :create, @invalid_attrs))

      assert %{"errors" => errors} = json_response(conn, :bad_request)
    end
  end
end
