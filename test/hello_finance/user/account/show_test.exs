defmodule HelloFinance.User.Account.ShowTest do
  use HelloFinance.DataCase

  alias HelloFinance.User
  alias User.Account
  alias Account.Show

  @valid_attrs_no_user %{code: "BRL", balance: 100}
  @helper_user_attrs %{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}

  describe "call/2" do
    test "when account id is valid and user is the owner, returns the account" do
      {:ok, user_struct} = User.build(@helper_user_attrs)
      {:ok, %User{id: user_id}} = Repo.insert(user_struct)

      params = Map.put(@valid_attrs_no_user, :user_id, user_id)

      {:ok, account_struct} = Account.build(params)
      {:ok, %Account{id: account_id}} = Repo.insert(account_struct)

      assert {:ok, %Account{user_id: user_id}} = Show.call(user_id, account_id)
    end

    test "when account id is invalid, returns an error" do
      {:ok, user_struct} = User.build(@helper_user_attrs)
      {:ok, %User{id: user_id}} = Repo.insert(user_struct)

      assert {:error, message} = Show.call(user_id, -1)
      assert message == [message: "account not found"]
    end

    test "when account id is valid and user is not the owner, returns an error" do
      {:ok, owner_struct} = User.build(@helper_user_attrs)
      {:ok, %User{id: owner_id}} = Repo.insert(owner_struct)

      params = Map.put(@valid_attrs_no_user, :user_id, owner_id)

      {:ok, account_struct} = Account.build(params)
      {:ok, %Account{id: account_id}} = Repo.insert(account_struct)

      {:ok, thief_struct} = User.build(Map.put(@helper_user_attrs, :email, "thief@gmail.com"))
      {:ok, %User{id: thief_id}} = Repo.insert(thief_struct)

      assert {:error, message} = Show.call(thief_id, account_id)
      assert message == [message: "user is not the owner of this account"]
    end
  end
end
