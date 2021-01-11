defmodule HelloFinanceWeb.TransfersController do
  use HelloFinanceWeb, :controller

  action_fallback HelloFinanceWeb.FallbackController

  def create(conn, %{"from" => from, "to" => to} = params) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    params =
      params
      |> Map.put("sender_account_id", from)
      |> Map.put("receiver_account_id", to)
      |> Map.put("sender_id", user_id)

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
