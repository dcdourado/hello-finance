defmodule HelloFinanceWeb.UsersView do
  use HelloFinanceWeb, :view

  alias HelloFinance.User

  def render("create.json", %{user: %User{id: id, name: name}}) do
    %{
      message: "User created",
      data: %{
        id: id,
        name: name
      }
    }
  end
end
