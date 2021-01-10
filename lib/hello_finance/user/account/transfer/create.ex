defmodule HelloFinance.User.Account.Transfer.Create do
  alias Ecto.Multi
  alias HelloFinance.Repo
  alias HelloFinance.User.Account
  alias Account.Transfer

  def call(params) do
    params
    |> Transfer.build()
    |> create_transfer()
  end

  defp create_transfer({:error, _changeset} = error), do: error

  defp create_transfer(
         {:ok,
          %Transfer{
            currency: currency,
            value: value,
            sender_account_id: sender_account_id,
            receiver_account_id: receiver_account_id
          } = struct}
       ) do
    Multi.new()
    |> Multi.insert(:transfer, struct)
    |> Multi.update(
      :sender_account,
      get_account_transfer_changeset(sender_account_id, currency, -value)
    )
    |> Multi.update(
      :receiver_account,
      get_account_transfer_changeset(receiver_account_id, currency, value)
    )
    |> Repo.transaction()
  end

  defp get_account_transfer_changeset(account_id, currency, value) do
    {:ok, %{currency: account_currency, balance: account_balance} = account} =
      HelloFinance.get_account(account_id)

    value = get_exchanged_value(value, currency, account_currency)

    Account.changeset(account, %{balance: account_balance + value})
  end

  defp get_exchanged_value(value, from_currency, to_currency) when from_currency == to_currency,
    do: value

  defp get_exchanged_value(value, from_currency, to_currency) when from_currency != to_currency do
    {:ok, money} = HelloFinance.exchange_currency(from_currency, value, to_currency)

    %{value: value} = money
    value
  end
end
