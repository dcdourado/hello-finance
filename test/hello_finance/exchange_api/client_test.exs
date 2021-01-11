defmodule HelloFinance.ExchangeApi.ClientTest do
  use ExUnit.Case

  import Tesla.Mock

  alias HelloFinance.ExchangeApi.Client

  @base_url "https://api.exchangeratesapi.io/latest/"

  describe "get_rate/1" do
    test "when currency codes are valid, returns the exchange rate" do
      body = %{"base" => "USD", "date" => "2021-01-08", "rates" => %{"BRL" => 5.3671836735}}

      mock(fn
        %{method: :get, url: @base_url <> "?base=USD&symbols=BRL"} ->
          %Tesla.Env{status: 200, body: body}
      end)

      assert {:ok, response} = Client.get_rate("USD", "BRL")

      assert response == %{
               "base" => "USD",
               "date" => "2021-01-08",
               "rates" => %{"BRL" => 5.3671836735}
             }
    end

    test "when any currency code is invalid, returns an error" do
      mock(fn
        %{method: :get, url: @base_url <> "?base=INV&symbols=ALID"} ->
          %Tesla.Env{status: 400}
      end)

      assert {:error, response} = Client.get_rate("INV", "ALID")

      assert response == [:code, "not found"]
    end

    test "when there is an unexpected error, returns the error" do
      mock(fn %{method: :get, url: @base_url <> "?base=USD&symbols=BRL"} ->
        {:error, :timeout}
      end)

      assert {:error, response} = Client.get_rate("USD", "BRL")

      assert response == :timeout
    end
  end
end
