defmodule HelloFinance.UserTest do
  use HelloFinance.DataCase

  alias HelloFinance.{User, Repo}

  describe "build/1" do
    test "when all params are valid, returns a valid changeset" do
      params = %{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}

      result = User.build(params)

      assert {:ok, %User{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}} =
               result
    end

    test "when a required param is not inserted, returns an error" do
      no_name_params = %{email: "dcdourado@gmail.com", password: "123456"}
      {:error, no_name_result} = User.build(no_name_params)

      assert %Ecto.Changeset{valid?: false} = no_name_result
      assert errors_on(no_name_result) == %{name: ["can't be blank"]}

      no_email_params = %{name: "Diogo", password: "123456"}
      {:error, no_email_result} = User.build(no_email_params)

      assert %Ecto.Changeset{valid?: false} = no_email_result
      assert errors_on(no_email_result) == %{email: ["can't be blank"]}

      no_password_params = %{name: "Diogo", email: "dcdourado@gmail.com"}
      {:error, no_password_result} = User.build(no_password_params)

      assert %Ecto.Changeset{valid?: false} = no_password_result
      assert errors_on(no_password_result) == %{password: ["can't be blank"]}
    end

    test "when password do not attend min length (6), returns an error" do
      params = %{name: "Diogo", email: "dcdourado@gmail.com", password: "12345"}
      {:error, result} = User.build(params)

      assert %Ecto.Changeset{valid?: false} = result
      assert errors_on(result) == %{password: ["should be at least 6 character(s)"]}
    end

    test "when email has invalid format, returns an error" do
      params = %{name: "Diogo", email: "dcdourado.com", password: "123456"}
      {:error, result} = User.build(params)

      assert %Ecto.Changeset{valid?: false} = result
      assert errors_on(result) == %{email: ["has invalid format"]}
    end

    test "when email has already been taken, returns an error" do
      params = %{name: "Diogo", email: "dcdourado@gmail.com", password: "123456"}
      {:ok, user} = User.build(params)

      Repo.insert(user)

      {:error, result} = User.build(params)

      assert %Ecto.Changeset{valid?: false} = result
      assert errors_on(result) == %{email: ["has already been taken"]}
    end
  end
end
