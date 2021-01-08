defmodule HelloFinanceWeb.AccountsView do
  use HelloFinanceWeb, :view

  alias HelloFinance.User.Account

  def render("create.json", %{account: %Account{id: id, currency: currency, balance: balance}}) do
    %{
      message: "Account created",
      data: %{
        id: id,
        currency: currency,
        balance: balance
      }
    }
  end
end
