defmodule HelloFinanceWeb.TransfersView do
  use HelloFinanceWeb, :view

  alias HelloFinance.User.Account.Transfer

  def render("create.json", %{
        transfer: %Transfer{
          id: id,
          currency: currency,
          value: value,
          sender_account_id: sender_account_id,
          receiver_account_id: receiver_account_id
        }
      }) do
    %{
      message: "Transfer created",
      data: %{
        id: id,
        currency: currency,
        value: value,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id
      }
    }
  end
end
