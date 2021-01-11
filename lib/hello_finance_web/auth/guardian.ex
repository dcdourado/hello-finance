defmodule HelloFinanceWeb.Auth.Guardian do
  use Guardian, otp_app: :hello_finance

  alias HelloFinance.{Repo, User}

  def subject_for_token(user, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    claims
    |> Map.get("sub")
    |> HelloFinance.get_user()
  end

  def authenticate(%{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, :unauthorized}
      user -> validate_password(user, password)
    end
  end

  defp validate_password(%User{password_hash: password_hash} = user, password) do
    case Argon2.verify_pass(password, password_hash) do
      true -> create_token(user)
      false -> {:error, :unauthorized}
    end
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, token}
  end
end
