defmodule HelloFinance.User.Account.Transfer do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias HelloFinance.Currency
  alias HelloFinance.User.Account

  schema "transfers" do
    field :currency, :string
    field :value, :integer
    field :sender_id, :integer, virtual: true
    belongs_to(:sender_account, Account)
    belongs_to(:receiver_account, Account)
    timestamps()
  end

  @required_params [:currency, :value, :sender_id, :sender_account_id, :receiver_account_id]

  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  def changeset(params), do: create_changeset(%__MODULE__{}, params)

  defp create_changeset(module, params) do
    module
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_money()
    |> validate_sender_account()
    |> validate_receiver_account()
  end

  defp validate_money(%Changeset{valid?: false} = changeset), do: changeset

  defp validate_money(%Changeset{changes: %{currency: currency, value: value}} = changeset) do
    case Currency.build(currency, value) do
      {:ok, _currency} -> changeset
      _error -> changeset |> add_error(:currency, "invalid") |> add_error(:value, "invalid")
    end
  end

  defp validate_sender_account(%Changeset{valid?: false} = changeset), do: changeset

  defp validate_sender_account(
         %Changeset{changes: %{sender_account_id: sender_account_id}} = changeset
       ) do
    case Account.Get.call(sender_account_id) do
      {:ok, account} ->
        changeset
        |> validate_sender_ownership(account)
        |> validate_sender_currency_value(account)

      _error ->
        add_error(changeset, :sender_account_id, "not found")
    end
  end

  defp validate_sender_ownership(
         %Changeset{changes: %{sender_id: sender_id}} = changeset,
         account
       ) do
    %{user_id: account_user_id} = account

    case sender_id do
      ^account_user_id -> changeset
      _not_owner -> add_error(changeset, :sender_id, "not owner of account")
    end
  end

  defp validate_sender_currency_value(
         %Changeset{changes: %{currency: currency, value: value}} = changeset,
         account
       ) do
    %{currency: account_currency, balance: account_balance} = account

    if currency == account_currency and value <= account_balance do
      changeset
    else
      add_error(changeset, :sender_account_id, "insufficient funds or wrong currency code")
    end
  end

  defp validate_receiver_account(%Changeset{valid?: false} = changeset), do: changeset

  defp validate_receiver_account(
         %Changeset{
           changes: %{
             receiver_account_id: receiver_account_id
           }
         } = changeset
       ) do
    case Account.Get.call(receiver_account_id) do
      {:ok, _account} -> changeset
      _error -> add_error(changeset, :receiver_account_id, "not found")
    end
  end
end
