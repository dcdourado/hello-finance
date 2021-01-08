defmodule HelloFinance.User.CreateTest do
  use HelloFinance.DataCase

  alias HelloFinance.{Repo, User}
  alias User.Create

  @valid_attrs %{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}
  @invalid_attrs %{name: "Diogo", email: "dcdouradogmail.com", password: "123"}

  describe "call/1" do
    test "when all params are valid, inserts user to database" do
      assert {:ok, result} = Create.call(@valid_attrs)

      assert %User{name: "Diogo", email: "dcdourado@gmail.com"} = result
    end

    test "when params are invalid, returns an error" do
      assert {:error, result} = Create.call(@invalid_attrs)

      assert Repo.get_by(User, email: "dcdouradogmail.com") == nil
    end
  end
end
