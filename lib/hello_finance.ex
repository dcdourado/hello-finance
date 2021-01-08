defmodule HelloFinance do
  alias HelloFinance.User
  alias User.Account

  defdelegate create_user(params), to: User.Create, as: :call

  defdelegate create_account(params), to: Account.Create, as: :call
end
