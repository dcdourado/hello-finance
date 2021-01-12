defmodule HelloFinanceWeb.AccountsView do
  use HelloFinanceWeb, :view

  alias HelloFinance.User.Account
  alias Account.Transfer

  def render("create.json", %{account: %Account{id: id, code: code, balance: balance}}) do
    %{
      message: "Account created",
      data: %{
        id: id,
        code: code,
        balance: balance
      }
    }
  end

  def render("index.json", %{account: accounts}) do
    accounts =
      Enum.map(accounts, fn %Account{id: id, code: code, balance: balance} ->
        %{
          id: id,
          code: code,
          balance: balance
        }
      end)

    %{
      message: "Accounts fetched",
      data: accounts
    }
  end

  def render("show.json", %{
        account: %Account{
          id: id,
          code: code,
          balance: balance,
          sent_transfers: sent_transfers,
          received_transfers: received_transfers
        }
      }) do
      sent_transfers = Enum.map(sent_transfers, fn %Transfer{id: id, code: code, value: value, receiver_account_id: receiver_account_id, inserted_at: inserted_at} ->
        %{
          id: id,
          code: code,
          value: value,
          receiver_account_id: receiver_account_id,
          inserted_at: inserted_at
        }
      end)

      received_transfers = Enum.map(received_transfers, fn %Transfer{id: id, code: code, value: value, sender_account_id: sender_account_id, inserted_at: inserted_at} ->
        %{
          id: id,
          code: code,
          value: value,
          sender_account_id: sender_account_id,
          inserted_at: inserted_at
        }
      end)

      account = %{
        id: id,
        code: code,
        balance: balance,
        sent_transfers: sent_transfers,
        received_transfers: received_transfers
      }

      %{
        message: "Account fetched",
        data: account
      }
  end
end
