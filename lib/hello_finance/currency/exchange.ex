defmodule HelloFinance.Currency.Exchange do
  alias HelloFinance.Currency

  def call(from_code, from_value, to_code, to_value) do
    build_currencies(from_code, from_value, to_code, to_value)
  end

  defp build_currencies(from_code, from_value, to_code, to_value) do
    Currency.build(from_code, from_value)
    |> put_currency(Currency.build(to_code, to_value))
  end

  defp put_currency({:ok, from_currency}, {:ok, to_currency}) do
    %{from: from_currency, to: to_currency}
  end

  defp put_currency({:error, [message: message]}, _to_currency) do
    {:error, message: "from currency #{message}"}
  end

  defp put_currency(_from_currency, {:error, [message: message]}) do
    {:error, message: "to currency #{message}"}
  end
end
