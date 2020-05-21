defmodule Alpaca.Client do
  @moduledoc """
  Client responsible for making requests to Alpaca and handling the responses.

  This client allows us to define all of our HTTP request logic and configuration
  in one place so that we can easily change or adapt this away from all of the other
  business logic of our library.
  """

  defmodule MissingCredentialsError do
    @moduledoc """
    Exception for when a request is made without a Client ID and Secret.
    """

    defexception message: """
                   The client_id and client_secret settings are required to make requests to Alpaca.
                   Please configure :client_id and :client_secret in config.exs or set the ALPACA_CLIENT_ID
                   and ALPACA_CLIENT_SECRET environment variable.
                   config :alpaca_elixir, client_id: CLIENT_ID, client_secret: CLIENT_SECRET
                 """
  end

  @spec client_id(atom) :: String.t()
  def client_id(env_key \\ :client_id) do
    case Confex.get_env(:alpaca_elixir, env_key, System.get_env("ALPACA_CLIENT_ID")) || :not_found do
      :not_found -> raise MissingCredentialsError
      value -> value
    end
  end

  @spec client_secret(atom) :: String.t()
  def client_secret(env_key \\ :client_secret) do
    case Confex.get_env(:alpaca_elixir, env_key, System.get_env("ALPACA_CLIENT_SECRET")) ||
           :not_found do
      :not_found -> raise MissingCredentialsError
      value -> value
    end
  end

  @spec api_host :: String.t()
  def api_host,
    do: Application.get_env(:alpaca_elixir, :api_host, System.get_env("ALPACA_API_HOST"))

  def get(url) do
    create()
    |> Tesla.get(url)
  end

  defp create() do
    middleware = [
      {Tesla.Middleware.BaseUrl, api_host()},
      {Tesla.Middleware.Headers, default_headers()},
      Alpaca.ResponseMiddleware
    ]

    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}

    Tesla.client(middleware, adapter)
  end

  @spec default_headers() :: %{String.t() => String.t()}
  defp default_headers() do
    [
      {"APCA-API-KEY-ID", client_id()},
      {"APCA-API-SECRET-KEY", client_secret()}
    ]
  end
end
