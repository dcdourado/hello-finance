defmodule HelloFinance.User.Account.IndexTest do
  use HelloFinance.DataCase

  alias HelloFinance.User
  alias User.Account
  alias Account.Index

  @valid_attrs_no_user %{code: "BRL", balance: 100}
  @helper_user_attrs %{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}

  describe "call/1" do
    test "when user_id is valid, returns user accounts" do
      {:ok, user_struct} = User.build(@helper_user_attrs)
      {:ok, %User{id: user_id}} = Repo.insert(user_struct)

      params = Map.put(@valid_attrs_no_user, :user_id, user_id)

      {:ok, account_struct} = Account.build(params)
      {:ok, _account} = Repo.insert(account_struct)

      assert {:ok, [%Account{user_id: user_id}]} = Index.call(user_id)
    end
  end
end
