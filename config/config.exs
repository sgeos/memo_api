# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :memo_api, MemoApi.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "/rEzNuhd+hkS84xFJtUrm/H1/ryIh9CvqFVINX6pSmLw8RxSaYS1B6FlGGdZhqlS",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: MemoApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "MemoApi",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "cXhDW/sid58fr+w7d9msUdXnmGs/kyffw8Y0Uhyro5bUbZWQFm/QprFh9/nNOhZa",
  serializer: MemoApi.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
