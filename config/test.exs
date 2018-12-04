use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :caissa, CaissaWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :chess_db, ChessDb.Repo,
database: "chess_db_test",
username: "postgres",
password: "postgres",
hostname: "localhost",
pool: Ecto.Adapters.SQL.Sandbox
