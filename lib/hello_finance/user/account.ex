defmodule HelloFinance.User.Account do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias HelloFinance.Currency
  alias HelloFinance.User

  schema "accounts" do
    field :currency, :string
    field :balance, :integer
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

  def changeset(account, params), do: create_changeset(account, params)

  defp create_changeset(module, params) do
    module
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_money()
    |> validate_user()
  end

  # TODO: add_error separately for each case
  defp validate_money(
         %Changeset{valid?: true, changes: %{currency: currency, balance: balance}} = changeset
       ) do
    case Currency.build(currency, balance) do
      {:ok, _currency} -> changeset
      _error -> changeset |> add_error(:currency, "invalid") |> add_error(:balance, "invalid")
    end
  end

  defp validate_money(changeset), do: changeset

  defp validate_user(%Changeset{valid?: true, changes: %{user_id: id}} = changeset) do
    case User.Get.call(id) do
      {:ok, _user} -> changeset
      _error -> add_error(changeset, :user_id, "not found")
    end
  end

  defp validate_user(changeset), do: changeset
end
