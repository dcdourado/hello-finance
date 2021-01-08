defmodule HelloFinance.CurrencyTest do
  use HelloFinance.DataCase

  alias HelloFinance.Currency

  describe "build/2" do
    test "when all params are valid, returns currency" do
      assert {:ok, result} = Currency.build(:BRL, 100)

      assert result == %Currency{code: :BRL, value: 100}
    end

    test "when code doest not exist, returns an error" do
      assert {:error, result} = Currency.build(:INVALID, 100)

      assert result == [message: "code not found"]
    end

    test "when value is negative, returns an error" do
      assert {:error, result} = Currency.build(:BRL, -100)

      assert result == [message: "value should be positive"]
    end

    test "when value is not an integer, returns an error" do
      assert {:error, result} = Currency.build(:BRL, 100.10)

      assert result == [message: "value should be an integer"]
    end
  end
end
