defmodule HelloFinance.User.GetTest do
  use HelloFinance.DataCase

  alias HelloFinance.User
  alias User.Get

  @user_attrs %{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}

  describe "call/1" do
    test "when the given id exists, returns the user" do
      assert {:ok, user} = HelloFinance.create_user(@user_attrs)

      %User{id: id} = user
      assert {:ok, result} = Get.call(id)
    end

    test "when the given id does not exists, returns an error" do
      assert {:error, result} = Get.call(-1)

      assert result == [message: "user not found"]
    end
  end
end
