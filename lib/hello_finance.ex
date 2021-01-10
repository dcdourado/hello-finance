defmodule HelloFinance do
  alias HelloFinance.Currency
  alias HelloFinance.User
  alias User.Account
  alias Account.Transfer

  defdelegate create_user(params), to: User.Create, as: :call
  defdelegate get_user(params), to: User.Get, as: :call

  defdelegate create_account(params), to: Account.Create, as: :call
  defdelegate get_account(params), to: Account.Get, as: :call

  defdelegate create_transfer(params), to: Transfer.Create, as: :call

  defdelegate exchange_currency(value, from_code, to_code), to: Currency.Exchange, as: :call
end
