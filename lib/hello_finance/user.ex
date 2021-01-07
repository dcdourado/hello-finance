defmodule HelloFinance.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias HelloFinance.{Repo, User}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    timestamps()
  end

  @required_params [:name, :email, :password]

  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  defp changeset(params), do: create_changeset(%__MODULE__{}, params)

  defp create_changeset(module, params) do
    module
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_format(:email, ~r/@/)
    |> validate_unique_email()
    |> validate_length(:password, min: 6)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset) do
    changeset
  end

  defp validate_unique_email(%Changeset{valid?: true, changes: %{email: email}} = changeset) do
    case Repo.get_by(User, email: email) do
      nil -> changeset
      _user -> add_error(changeset, :email, "has already been taken")
    end
  end

  defp validate_unique_email(changeset) do
    changeset
  end
end
