defmodule HelloFinance.User.Account.Get do
  alias HelloFinance.{Repo, User.Account}

  def call(id) do
    case fetch_account(id) do
      nil -> {:error, message: "account not found"}
      account -> {:ok, account}
    end
  end

  defp fetch_account(id), do: Repo.get(Account, id)
end
