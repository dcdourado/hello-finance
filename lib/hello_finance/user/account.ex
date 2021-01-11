defmodule HelloFinance.User.Account do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias HelloFinance.Currency
  alias HelloFinance.User

  schema "accounts" do
    field :code, :string
    field :balance, :integer
    belongs_to(:user, User)
    timestamps()
  end

  @required_params [:code, :balance, :user_id]

  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  def changeset(params), do: create_changeset(%__MODULE__{}, params)

  def changeset(account, params), do: create_changeset(account, params)

  defp create_changeset(module, params) do
    module
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_currency()
    |> validate_user()
  end

  defp validate_currency(
         %Changeset{valid?: true, changes: %{code: code, balance: balance}} = changeset
       ) do
    case Currency.build(code, balance) do
      {:ok, _currency} -> changeset
      {:error, [key, message]} -> add_error(changeset, key, message)
    end
  end

  defp validate_currency(changeset), do: changeset

  defp validate_user(%Changeset{valid?: true, changes: %{user_id: id}} = changeset) do
    case User.Get.call(id) do
      {:ok, _user} -> changeset
      _nil -> add_error(changeset, :user_id, "not found")
    end
  end

  defp validate_user(changeset), do: changeset
end
