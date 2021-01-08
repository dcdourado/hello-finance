defmodule HelloFinance.CurrencyTest do
  use HelloFinance.DataCase

  alias HelloFinance.Currency

  describe "build/2" do
    test "when all params are valid, returns currency" do
      result = Currency.build(:BRL, 100)

      assert result == %Currency{code: :BRL, value: 100}
    end

    test "when code doest not exist, returns an error" do
      result = Currency.build(:INVALID, 100)

      assert result == {:error, message: "code not found"}
    end

    test "when value is negative, returns an error" do
      result = Currency.build(:BRL, -100)

      assert result == {:error, message: "value should be positive"}
    end

    test "when value is not an integer, returns an error" do
      result = Currency.build(:BRL, 100.10)

      assert result == {:error, message: "value should be an integer"}
    end
  end
end
