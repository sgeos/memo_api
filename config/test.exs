use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :memo_api, MemoApi.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

# Configure your database
config :memo_api, MemoApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "memo_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
