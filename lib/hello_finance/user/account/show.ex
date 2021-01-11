defmodule HelloFinance.User.Account.Show do
  alias HelloFinance.User.Account

  def call(user_id, account_id) do
    case Account.Get.call(account_id) do
      {:ok, account} -> validate_ownership(account, user_id)
      error -> error
    end
  end

  defp validate_ownership(%Account{user_id: account_user_id} = account, user_id) do
    case account_user_id do
      ^user_id -> {:ok, account}
      _other_user_id -> {:error, message: "user is not the owner of this account"}
    end
  end
end
