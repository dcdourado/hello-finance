defmodule HelloFinance.User.CreateTest do
  use HelloFinance.DataCase

  alias HelloFinance.{Repo, User}
  alias User.Create

  @valid_attrs %{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}
  @invalid_attrs %{name: "Diogo", email: "dcdouradogmail.com", password: "123"}

  describe "call/1" do
    test "when all params are valid, inserts user to database" do
      result = Create.call(@valid_attrs)

      assert {:ok, %User{name: "Diogo", email: "dcdourado@gmail.com"}} = result

      {:ok, %User{id: id}} = result
      assert %User{name: "Diogo", email: "dcdourado@gmail.com"} = Repo.get(User, id)
    end

    test "when params are invalid, returns an error" do
      result = Create.call(@invalid_attrs)

      assert {:error, _user} = result

      assert Repo.get_by(User, email: "dcdouradogmail.com") == nil
    end
  end
end
