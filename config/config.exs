# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hello_finance,
  ecto_repos: [HelloFinance.Repo]

# Configures the endpoint
config :hello_finance, HelloFinanceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+yvuSURysfb422uKRRof2p0SC3Tkgjd88hqgk2k+0F/Tm8neIZvJYDmZMXSeCFgr",
  render_errors: [view: HelloFinanceWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: HelloFinance.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "irc9e0c+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# TODO: add secret_key to env variable
config :hello_finance, HelloFinanceWeb.Auth.Guardian,
  issuer: "hello_finance",
  secret_key: "UPr37H9lSEsnLWlzm8Jl7SlRNo/5DI94JGjCuUPdkw8QfljHPrN9dWjgu18CWMhA"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
