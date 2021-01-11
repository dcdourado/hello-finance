defmodule HelloFinance.User.Account.TransferTest do
  use HelloFinance.DataCase

  alias HelloFinance.User
  alias User.Account
  alias Account.Transfer

  @helper_user_attrs %{name: "Diogo", password: "123456", email: "dcdourado@gmail.com"}

  describe "build/1" do
    setup do
      {:ok, user_struct} = User.build(@helper_user_attrs)
      {:ok, %User{id: user_id}} = Repo.insert(user_struct)

      account_params = %{currency: "BRL", balance: 1000, user_id: user_id}

      {:ok, account_struct} = Account.build(account_params)
      {:ok, %Account{id: sender_account_id}} = Repo.insert(account_struct)
      {:ok, %Account{id: receiver_account_id}} = Repo.insert(account_struct)

      {:ok,
       user_id: user_id,
       sender_account_id: sender_account_id,
       receiver_account_id: receiver_account_id}
    end

    test "when all params are valid, returns a Transfer struct", %{
      user_id: user_id,
      sender_account_id: sender_account_id,
      receiver_account_id: receiver_account_id
    } do
      params = %{
        currency: "BRL",
        value: 1000,
        sender_id: user_id,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id
      }

      assert {:ok, transfer_struct} = Transfer.build(params)

      assert %Transfer{
               currency: "BRL",
               value: 1000,
               sender_account_id: sender_account_id,
               receiver_account_id: receiver_account_id
             } = transfer_struct
    end

    test "when transfer currency is invalid, returns an error", %{
      user_id: user_id,
      sender_account_id: sender_account_id,
      receiver_account_id: receiver_account_id
    } do
      params = %{
        currency: "INVALID",
        value: 1000,
        sender_id: user_id,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id
      }

      assert {:error, changeset} = Transfer.build(params)

      assert errors_on(changeset) == %{currency: ["invalid"], value: ["invalid"]}
    end

    test "when value is invalid, returns an error", %{
      user_id: user_id,
      sender_account_id: sender_account_id,
      receiver_account_id: receiver_account_id
    } do
      params = %{
        currency: "BRL",
        value: -1000,
        sender_id: user_id,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id
      }

      assert {:error, changeset} = Transfer.build(params)

      assert errors_on(changeset) == %{currency: ["invalid"], value: ["invalid"]}
    end

    test "when transfer currency is not equal to sender account currency, returns an error", %{
      user_id: user_id,
      sender_account_id: sender_account_id,
      receiver_account_id: receiver_account_id
    } do
      params = %{
        currency: "USD",
        value: 1000,
        sender_id: user_id,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id
      }

      assert {:error, changeset} = Transfer.build(params)

      assert errors_on(changeset) == %{
               sender_account_id: ["insufficient funds or wrong currency code"]
             }
    end

    test "when sender does not have enough money, returns an error", %{
      user_id: user_id,
      sender_account_id: sender_account_id,
      receiver_account_id: receiver_account_id
    } do
      params = %{
        currency: "BRL",
        value: 100_000,
        sender_id: user_id,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id
      }

      assert {:error, changeset} = Transfer.build(params)

      assert errors_on(changeset) == %{
               sender_account_id: ["insufficient funds or wrong currency code"]
             }
    end

    test "when sender account does not exists, returns an error", %{
      user_id: user_id,
      receiver_account_id: receiver_account_id
    } do
      params = %{
        currency: "BRL",
        value: 1000,
        sender_id: user_id,
        sender_account_id: -1,
        receiver_account_id: receiver_account_id
      }

      assert {:error, changeset} = Transfer.build(params)

      assert errors_on(changeset) == %{sender_account_id: ["not found"]}
    end

    test "when receiver account does not exists, returns an error", %{
      user_id: user_id,
      sender_account_id: sender_account_id
    } do
      params = %{
        currency: "BRL",
        value: 1000,
        sender_id: user_id,
        sender_account_id: sender_account_id,
        receiver_account_id: -1
      }

      assert {:error, changeset} = Transfer.build(params)

      assert errors_on(changeset) == %{receiver_account_id: ["not found"]}
    end
  end
end
