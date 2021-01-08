defmodule HelloFinance.User.Account do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias HelloFinance.User

  schema "accounts" do
    field :balance, :integer
    field :currency, :string
    belongs_to(:user, User)
    timestamps()
  end

  @required_params [:balance, :currency, :user_id]

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
    |> validate_user()
  end

  defp validate_user(%Changeset{changes: %{user_id: id}} = changeset) do
    case User.Get.call(id) do
      {:ok, _user} -> changeset
      _error -> add_error(changeset, :user_id, "not found")
    end
  end
end
