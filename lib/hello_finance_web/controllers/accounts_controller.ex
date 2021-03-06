defmodule HelloFinanceWeb.AccountsController do
  use HelloFinanceWeb, :controller

  action_fallback HelloFinanceWeb.FallbackController

  def create(conn, params) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    params = Map.put(params, "user_id", user_id)

    params
    |> HelloFinance.create_account()
    |> handle_response(conn, "create.json", :created)
  end

  def index(conn, _params) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    user_id
    |> HelloFinance.index_accounts()
    |> handle_response(conn, "index.json", :ok)
  end

  def show(conn, %{"id" => account_id}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    params = %{account_id: account_id, user_id: user_id}

    params
    |> HelloFinance.show_account()
    |> handle_response(conn, "show.json", :ok)
  end

  defp handle_response({:ok, account}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, account: account)
  end

  defp handle_response({:error, _changeset} = error, _conn, _view, _status), do: error
end
