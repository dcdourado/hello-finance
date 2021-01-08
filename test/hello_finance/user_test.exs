defmodule HelloFinance.UserTest do
  use HelloFinance.DataCase

  alias HelloFinance.{User, Repo}

  @valid_attrs %{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}
  @no_name_attrs %{email: "dcdourado@gmail.com", password: "123456"}
  @no_email_attrs %{name: "Diogo", password: "123456"}
  @no_password_attrs %{name: "Diogo", email: "dcdourado@gmail.com"}
  @invalid_password_attrs %{name: "Diogo", email: "dcdourado@gmail.com", password: "12345"}
  @invalid_email_attrs %{name: "Diogo", email: "dcdourado.com", password: "123456"}

  describe "build/1" do
    test "when all params are valid, returns an User struct" do
      result = User.build(@valid_attrs)

      assert {:ok, %User{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}} =
               result
    end

    test "when a required param is not inserted, returns an error" do
      {:error, no_name_result} = User.build(@no_name_attrs)

      assert %Ecto.Changeset{valid?: false} = no_name_result
      assert errors_on(no_name_result) == %{name: ["can't be blank"]}

      {:error, no_email_result} = User.build(@no_email_attrs)

      assert %Ecto.Changeset{valid?: false} = no_email_result
      assert errors_on(no_email_result) == %{email: ["can't be blank"]}

      {:error, no_password_result} = User.build(@no_password_attrs)

      assert %Ecto.Changeset{valid?: false} = no_password_result
      assert errors_on(no_password_result) == %{password: ["can't be blank"]}
    end

    test "when password do not attend min length (6), returns an error" do
      {:error, result} = User.build(@invalid_password_attrs)

      assert %Ecto.Changeset{valid?: false} = result
      assert errors_on(result) == %{password: ["should be at least 6 character(s)"]}
    end

    test "when email has invalid format, returns an error" do
      {:error, result} = User.build(@invalid_email_attrs)

      assert %Ecto.Changeset{valid?: false} = result
      assert errors_on(result) == %{email: ["has invalid format"]}
    end

    test "when email has already been taken, returns an error" do
      {:ok, user} = User.build(@valid_attrs)

      Repo.insert(user)

      {:error, result} = User.build(@valid_attrs)

      assert %Ecto.Changeset{valid?: false} = result
      assert errors_on(result) == %{email: ["has already been taken"]}
    end
  end
end
