defmodule HelloFinance.User.Account.Transfer do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias HelloFinance.Currency
  alias HelloFinance.User.Account

  schema "transfers" do
    field :code, :string
    field :value, :integer
    field :sender_id, :integer, virtual: true
    belongs_to(:sender_account, Account)
    belongs_to(:receiver_account, Account)
    timestamps()
  end

  @required_params [:value, :sender_id, :sender_account_id, :receiver_account_id]

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
    |> validate_value()
    |> validate_sender_account_and_put_code()
    |> validate_receiver_account()
  end

  defp validate_value(%Changeset{valid?: false} = changeset), do: changeset

  defp validate_value(%Changeset{changes: %{value: value}} = changeset) do
    # We are just validating the value here, so we use any valid code
    test_code = :USD

    case Currency.build(test_code, value) do
      {:ok, _currency} -> changeset
      {:error, [key, message]} -> add_error(changeset, key, message)
    end
  end

  defp validate_sender_account_and_put_code(%Changeset{valid?: false} = changeset), do: changeset

  defp validate_sender_account_and_put_code(
         %Changeset{changes: %{sender_account_id: sender_account_id}} = changeset
       ) do
    case Account.Get.call(sender_account_id) do
      {:ok, account} ->
        changeset
        |> put_code(account)
        |> validate_sender_ownership(account)
        |> validate_sender_balance(account)

      _nil ->
        add_error(changeset, :sender_account_id, "not found")
    end
  end

  defp put_code(changeset, %Account{code: code}) do
    put_change(changeset, :code, code)
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

  defp validate_sender_balance(%Changeset{changes: %{value: value}} = changeset, account) do
    %{balance: account_balance} = account

    case value <= account_balance do
      true -> changeset
      false -> add_error(changeset, :sender_account_id, "insufficient funds")
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
