defmodule HelloFinance.Currency.ExchangeTest do
  use ExUnit.Case

  import Tesla.Mock

  alias HelloFinance.Currency.Exchange

  @base_url "https://api.exchangeratesapi.io/latest/"

  describe "call/3" do
    test "when all params are valid, returns a converted currency" do
      body = %{"base" => "USD", "date" => "2021-01-08", "rates" => %{"BRL" => 5}}

      mock(fn
        %{method: :get, url: @base_url <> "?base=USD&symbols=BRL"} ->
          %Tesla.Env{status: 200, body: body}
      end)

      assert {:ok, result} = Exchange.call(1, :USD, :BRL)
      assert result == %HelloFinance.Currency{code: :BRL, value: 5}
    end

    test "when codes are given as string, returns a converted currency" do
      body = %{"base" => "USD", "date" => "2021-01-08", "rates" => %{"BRL" => 5}}

      mock(fn
        %{method: :get, url: @base_url <> "?base=USD&symbols=BRL"} ->
          %Tesla.Env{status: 200, body: body}
      end)

      assert {:ok, result} = Exchange.call(1, "USD", "BRL")
      assert result == %HelloFinance.Currency{code: :BRL, value: 5}
    end

    test "when value is invalid, returns an error" do
      assert {:error, result} = Exchange.call(-1, :USD, :BRL)
      assert result == [:value, "should be positive"]
    end

    test "when from code is invalid, returns an error" do
      assert {:error, result} = Exchange.call(1, :INVALID, :BRL)
      assert result == [:code, "not found"]
    end

    test "when to code is invalid, returns an error" do
      mock(fn
        %{method: :get, url: @base_url <> "?base=USD&symbols=INVALID"} ->
          %Tesla.Env{status: 400}
      end)

      assert {:error, result} = Exchange.call(1, :USD, :INVALID)
      assert result == [message: "invalid currency code"]
    end
  end
end
