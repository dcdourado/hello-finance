defmodule HelloFinance.User.Account.CreateTest do
  use HelloFinance.DataCase

  alias HelloFinance.{Repo, User}
  alias User.Account
  alias Account.Create

  @valid_attrs_no_user %{code: "BRL", balance: 100}
  @helper_user_attrs %{name: "Diogo", password: "123456", email: "dcdourado@gmail.com"}

  describe "call/1" do
    test "when all params are valid, inserts account to database" do
      {:ok, user_struct} = User.build(@helper_user_attrs)
      {:ok, %User{id: id}} = Repo.insert(user_struct)

      params = Map.put(@valid_attrs_no_user, :user_id, id)

      assert {:ok, result} = Create.call(params)
      assert result = Repo.get_by(Account, user_id: id)
    end

    test "when params are invalid, returns an error" do
      assert {:error, result} = Create.call(@valid_attrs_no_user)

      assert errors_on(result) == %{user_id: ["can't be blank"]}
      assert Repo.get_by(Account, balance: 100) == nil
    end
  end
end
