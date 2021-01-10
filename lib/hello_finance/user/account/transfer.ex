defmodule HelloFinance.User.Account.Transfer do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias HelloFinance.Currency
  alias HelloFinance.User.Account

  schema "transfers" do
    field :currency, :string
    field :value, :integer
    belongs_to(:sender_account, Account)
    belongs_to(:receiver_account, Account)
    timestamps()
  end

  @required_params [:currency, :value, :sender_account_id, :receiver_account_id]

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
    |> validate_money()
  end

  defp validate_money(%Changeset{valid?: false} = changeset), do: changeset

  defp validate_money(%Changeset{changes: %{currency: currency, value: value}} = changeset) do
    case Currency.build(currency, value) do
      {:ok, _currency} -> changeset
      _error -> changeset |> add_error(:currency, "invalid") |> add_error(:value, "invalid")
    end
  end
end
