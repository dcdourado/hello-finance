defmodule HelloFinance.User.Account.GetTest do
  use HelloFinance.DataCase

  alias HelloFinance.User
  alias User.Account
  alias Account.Get

  @valid_attrs_no_user %{code: "BRL", balance: 100}
  @helper_user_attrs %{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}

  describe "call/1" do
    test "when the given id exists, returns the account" do
      {:ok, user_struct} = User.build(@helper_user_attrs)
      {:ok, %User{id: user_id}} = Repo.insert(user_struct)

      params = Map.put(@valid_attrs_no_user, :user_id, user_id)

      {:ok, account_struct} = Account.build(params)
      {:ok, %Account{id: account_id}} = Repo.insert(account_struct)

      assert {:ok, result} = Get.call(account_id)
      assert %Account{code: "BRL", balance: 100} = result
    end

    test "when the given id does not exists, returns an error" do
      assert {:error, result} = Get.call(-1)

      assert result == [message: "account not found"]
    end
  end
end
