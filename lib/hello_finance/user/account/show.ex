defmodule HelloFinance.User.Account.Show do
  alias HelloFinance.Repo
  alias HelloFinance.User.Account

  def call(params) do
    %{account_id: account_id, user_id: user_id} = params

    account_id
    |> Account.Get.call()
    |> validate_ownership(user_id)
    |> preload_transfers()
  end

  defp validate_ownership({:error, _message} = error, _user_id), do: error

  defp validate_ownership({:ok, %Account{user_id: account_user_id}} = result, user_id) do
    case account_user_id do
      ^user_id -> result
      _other_user_id -> {:error, message: "user is not the owner of this account"}
    end
  end

  defp preload_transfers({:error, _message} = error), do: error
  defp preload_transfers({:ok, account}), do: {:ok, Repo.preload(account, [:sent_transfers, :received_transfers])}
end
