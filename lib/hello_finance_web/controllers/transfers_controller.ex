defmodule HelloFinanceWeb.TransfersController do
  use HelloFinanceWeb, :controller

  action_fallback HelloFinanceWeb.FallbackController

  def create(conn, params) do
    params
    |> HelloFinance.create_transfer()
    |> handle_response(conn, "create.json", :created)
  end

  defp handle_response({:ok, %{transfer: transfer}}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, transfer: transfer)
  end

  defp handle_response({:error, _changeset} = error, _conn, _view, _status), do: error
end
