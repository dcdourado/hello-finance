defmodule HelloFinanceWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :hello_finance

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
