defmodule HelloFinanceWeb.AccountsView do
  use HelloFinanceWeb, :view

  alias HelloFinance.User.Account

  def render("create.json", %{account: %Account{id: id, code: code, balance: balance}}) do
    %{
      message: "Account created",
      data: %{
        id: id,
        code: code,
        balance: balance
      }
    }
  end
end
