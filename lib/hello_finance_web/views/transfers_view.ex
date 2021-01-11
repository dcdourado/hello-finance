defmodule HelloFinanceWeb.TransfersView do
  use HelloFinanceWeb, :view

  alias HelloFinance.User.Account.Transfer

  def render("create.json", %{
        transfer: %Transfer{
          id: id,
          code: code,
          value: value,
          sender_account_id: sender_account_id,
          receiver_account_id: receiver_account_id
        }
      }) do
    %{
      message: "Transfer created",
      data: %{
        id: id,
        code: code,
        value: value,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id
      }
    }
  end
end
