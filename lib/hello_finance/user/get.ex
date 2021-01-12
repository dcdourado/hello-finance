defmodule HelloFinance.User.Get do
  alias HelloFinance.{Repo, User}

  def call(id) do
    case fetch_user(id) do
      nil -> {:error, "user not found"}
      user -> {:ok, user}
    end
  end

  defp fetch_user(id), do: Repo.get(User, id)
end
