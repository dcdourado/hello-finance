defmodule HelloFinance do
  alias HelloFinance.User

  defdelegate create_user(params), to: User.Create, as: :call
end
