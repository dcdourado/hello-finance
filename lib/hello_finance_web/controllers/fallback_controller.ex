defmodule HelloFinanceWeb.FallbackController do
  use HelloFinanceWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(HelloFinanceWeb.ErrorView)
    |> render("401.json", result: "User unauthorized")
  end

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(HelloFinanceWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
