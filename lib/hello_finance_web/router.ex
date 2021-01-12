defmodule HelloFinanceWeb.Router do
  use HelloFinanceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug HelloFinanceWeb.Auth.Pipeline
  end

  scope "/api", HelloFinanceWeb do
    pipe_through :api

    post "/users", UsersController, :create
    post "/signin", UsersController, :sign_in
  end

  scope "/api", HelloFinanceWeb do
    pipe_through [:api, :auth]

    resources "/accounts", AccountsController, only: [:index, :show, :create]
    post "/accounts/:from/transfers", TransfersController, :create
  end
end
