defmodule HelloFinanceWeb.AccountsController do
  use HelloFinanceWeb, :controller

  action_fallback HelloFinanceWeb.FallbackController

  def create(conn, params) do
    params
    |> HelloFinance.create_account()
    |> handle_response(conn, "create.json", :created)
  end

  defp handle_response({:ok, account}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, account: account)
  end

  defp handle_response({:error, _changeset} = error, _conn, _view, _status), do: error
end
