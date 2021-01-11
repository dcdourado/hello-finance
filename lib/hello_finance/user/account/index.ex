defmodule HelloFinance.User.Account.Index do
  import Ecto.Query, only: [from: 2]

  alias HelloFinance.Repo
  alias HelloFinance.User.Account

  def call(user_id) do
    case fetch_accounts(user_id) do
      nil -> {:error, message: "account not found"}
      accounts -> {:ok, accounts}
    end
  end

  defp fetch_accounts(user_id) do
    query = from a in Account, where: a.user_id == ^user_id
    Repo.all(query)
  end
end
