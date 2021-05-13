use Mix.Config

config :alpaca_elixir,
  api_host: System.get_env("ALPACA_API_HOST") || "https://paper-api.alpaca.markets",
  client_id: System.get_env("ALPACA_CLIENT_ID") || "",
  client_secret: System.get_env("ALPACA_CLIENT_SECRET") || ""

config :exvcr,
  vcr_cassette_library_dir: "fixture/vcr_cassettes",
  custom_cassette_library_dir: "fixture/custom_cassettes",
  filter_sensitive_data: [],
  filter_url_params: false,
  filter_request_headers: ["APCA-API-KEY-ID", "APCA-API-SECRET-KEY"],
  response_headers_blacklist: []
