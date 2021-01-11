defmodule HelloFinance.User.AccountTest do
  use HelloFinance.DataCase

  alias HelloFinance.{Repo, User}
  alias User.Account

  @valid_attrs_no_user %{code: "BRL", balance: 100}
  @no_code_attrs %{balance: 100}
  @no_balance_attrs %{code: "BRL"}
  @invalid_code_attrs %{code: "INVALID", balance: 100}
  @invalid_balance_attrs %{code: "BRL", balance: -100}
  @helper_user_attrs %{name: "Diogo", password: "123456", email: "dcdourado@gmail.com"}

  describe "build/1" do
    setup do
      {:ok, user_struct} = User.build(@helper_user_attrs)
      {:ok, user} = Repo.insert(user_struct)

      %User{id: id} = user
      {:ok, id: id}
    end

    test "when all params are valid, returns an Account struct", %{id: id} do
      params = Map.put(@valid_attrs_no_user, :user_id, id)

      assert {:ok, result} = Account.build(params)

      assert %Account{balance: 100, code: "BRL"} = result
    end

    test "when a required param is not inserted, returns an error", %{id: id} do
      assert {:error, no_user_result} = Account.build(@valid_attrs_no_user)
      assert errors_on(no_user_result) == %{user_id: ["can't be blank"]}

      no_code_params = Map.put(@no_code_attrs, :user_id, id)
      assert {:error, no_code_result} = Account.build(no_code_params)
      assert errors_on(no_code_result) == %{code: ["can't be blank"]}

      no_balance_params = Map.put(@no_balance_attrs, :user_id, id)
      assert {:error, no_balance_result} = Account.build(no_balance_params)
      assert errors_on(no_balance_result) == %{balance: ["can't be blank"]}
    end

    test "when user does not exists, return an error" do
      params = Map.put(@valid_attrs_no_user, :user_id, -1)

      assert {:error, result} = Account.build(params)
      assert errors_on(result) == %{user_id: ["not found"]}
    end

    test "when code is invalid, returns an error", %{id: id} do
      params = Map.put(@invalid_code_attrs, :user_id, id)

      assert {:error, result} = Account.build(params)
    end

    test "when balance is invalid, returns an error", %{id: id} do
      params = Map.put(@invalid_balance_attrs, :user_id, id)

      assert {:error, result} = Account.build(params)
    end
  end
end
