defmodule HelloFinanceWeb.Router do
  use HelloFinanceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HelloFinanceWeb do
    pipe_through :api

    post "/users", UsersController, :create
  end
end
