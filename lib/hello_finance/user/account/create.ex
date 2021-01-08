defmodule HelloFinance.User.Account.Create do
  alias HelloFinance.{Repo, User}
  alias User.Account

  def call(params) do
    params
    |> Account.build()
    |> create_account()
  end

  defp create_account({:ok, struct}), do: Repo.insert(struct)
  defp create_account({:error, _changeset} = error), do: error
end
