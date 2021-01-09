defmodule HelloFinance.ExchangeApi.Client do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.exchangeratesapi.io/latest"
  plug Tesla.Middleware.JSON

  def get_rate(from, to) do
    "?base=#{from}&symbols=#{to}"
    |> get()
    |> handle_get()
  end

  defp handle_get({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}
  defp handle_get({:ok, %Tesla.Env{status: 400}}), do: {:error, message: "invalid currency code"}
  defp handle_get({:error, _reason} = error), do: error
end
