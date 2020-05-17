  use Mix.Config

config :alpaca_elixir,
  client_id: System.get_env("ALPACA_CLIENT_ID"),
  client_secret: System.get_env("ALPACA_CLIENT_SECRET")
