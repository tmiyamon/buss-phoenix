# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :buss_phoenix, BussPhoenix.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "0tiF3jKG1sHyHjvtsAYOFacqWVDU3Q4UYLbaGn5+KF7u0W8tJfs5gLQxJGsyBZ1c",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: BussPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :joken, config_module: Guardian.JWT

config :guardian, Guardian,
  issuer: "BussPhoenix",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: "io1980138019381381470170ruoweirjweorhweriowarwjrowija",
  serializer: BussPhoenix.GuardianSerializer

config :phoenix, :template_engines,
    slim: PhoenixSlim.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
