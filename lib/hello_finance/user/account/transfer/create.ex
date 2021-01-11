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
            code: code,
            value: value,
            sender_account_id: sender_account_id,
            receiver_account_id: receiver_account_id
          } = struct}
       ) do
    Multi.new()
    |> Multi.insert(:transfer, struct)
    |> Multi.update(
      :sender_account,
      get_account_transfer_changeset(sender_account_id, code, -value)
    )
    |> Multi.update(
      :receiver_account,
      get_account_transfer_changeset(receiver_account_id, code, value)
    )
    |> Repo.transaction()
  end

  defp get_account_transfer_changeset(account_id, code, value) do
    {:ok, %{code: account_code, balance: account_balance} = account} =
      HelloFinance.get_account(account_id)

    value = get_exchanged_value(value, code, account_code)

    Account.changeset(account, %{balance: account_balance + value})
  end

  defp get_exchanged_value(value, from_code, to_code) when from_code == to_code,
    do: value

  defp get_exchanged_value(value, from_code, to_code) when from_code != to_code do
    {:ok, money} = HelloFinance.exchange_code(value, from_code, to_code)

    %{value: value} = money
    value
  end
end
