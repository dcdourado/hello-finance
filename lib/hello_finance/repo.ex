defmodule HelloFinance.Repo do
  use Ecto.Repo,
    otp_app: :hello_finance,
    adapter: Ecto.Adapters.Postgres
end
