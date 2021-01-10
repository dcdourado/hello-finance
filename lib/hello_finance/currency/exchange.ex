defmodule HelloFinance.Currency.Exchange do
  alias HelloFinance.Currency
  alias HelloFinance.ExchangeApi.Client

  def call(from_code, from_value, to_code) do
    Currency.build(from_code, from_value)
    |> get_exchange_rate(to_code)
    |> parse_currency(to_code, from_value)
  end

  defp get_exchange_rate({:error, _message} = error, _to_code), do: error

  defp get_exchange_rate({:ok, %{code: from_code, value: _value}}, to_code) do
    to_code = parse_code_to_string(to_code)

    case Client.get_rate(from_code, to_code) do
      {:ok, %{"rates" => %{^to_code => to_rate}}} -> to_rate
      error -> error
    end
  end

  defp parse_code_to_string(code) when is_binary(code), do: code

  defp parse_code_to_string(code) when is_atom(code) do
    Atom.to_string(code)
  end

  defp parse_currency({:error, _message} = error, _to_code, _from_value), do: error

  defp parse_currency(rate, to_code, from_value) do
    Currency.build(to_code, trunc(rate * from_value))
  end
end
