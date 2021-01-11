defmodule HelloFinanceWeb.UsersController do
  use HelloFinanceWeb, :controller

  alias HelloFinanceWeb.Auth.Guardian

  action_fallback HelloFinanceWeb.FallbackController

  def create(conn, params) do
    params
    |> HelloFinance.create_user()
    |> handle_response(conn, "create.json", :created)
  end

  def sign_in(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("sign_in.json", token: token)
    end
  end

  defp handle_response({:ok, user}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, user: user)
  end

  defp handle_response({:error, _changeset} = error, _conn, _view, _status), do: error
end
