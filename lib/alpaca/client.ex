defmodule Alpaca.Client do
  @moduledoc """
  Client responsible for making requests to Alpaca and handling the responses.

  This client allows us to define all of our HTTP request logic and configuration
  in one place so that we can easily change or adapt this away from all of the other
  business logic of our library.

  We have access to HTTP request types on this client and it will automatically use a base
  url as well as set all the necessary headers for us.

  We have access to GET, POST, PATCH, and DELETE HTTP requests using this client.

  ### Example usage
  ```
  Alpaca.Client.get("/path", %{query_param: "value"})
  Alpaca.Client.post("/path", %{param1: "value"})
  Alpaca.Client.patch("/path", %{param1: "value"})
  Alpaca.Client.delete("/path")
  ```
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
  defp client_id(env_key \\ :client_id) do
    case Confex.get_env(:alpaca_elixir, env_key, System.get_env("ALPACA_CLIENT_ID")) || :not_found do
      :not_found -> raise MissingCredentialsError
      value -> value
    end
  end

  @spec client_secret(atom()) :: String.t()
  defp client_secret(env_key \\ :client_secret) do
    case Confex.get_env(:alpaca_elixir, env_key, System.get_env("ALPACA_CLIENT_SECRET")) ||
           :not_found do
      :not_found -> raise MissingCredentialsError
      value -> value
    end
  end

  @spec api_host :: String.t()
  defp api_host,
    do: Application.get_env(:alpaca_elixir, :api_host, System.get_env("ALPACA_API_HOST"))

  @doc """
  Issue a get request using the HTTP client

  Accepts path which is the url path of the request, will be added to the end of the base_url
  and a map of params which will become the query list for the get request
  """
  @spec get(String.t(), map()) :: {:ok, map()} | {:error, map()}
  def get(path, params \\ %{}) do
    create()
    |> Tesla.get(path, query: map_to_klist(params))
  end

  @doc """
  Issue a post request using the HTTP client

  Accepts path which is the url path of the request, will be added to the end of the base_url
  and a map of params which will be the body of the post request
  """
  @spec post(String.t(), map()) :: {:ok, map()} | {:error, map()}
  def post(path, params \\ %{}) do
    create()
    |> Tesla.post(path, params)
  end

  @doc """
  Issue a patch request using the HTTP client

  Accepts path which is the url path of the request, will be added to the end of the base_url
  and a map of params which will be the body of the post request
  """
  @spec patch(String.t(), map()) :: {:ok, map()} | {:error, map()}
  def patch(path, params \\ %{}) do
    create()
    |> Tesla.patch(path, params)
  end

  @doc """
  Issue a put request using the HTTP client

  Accepts path which is the url path of the request, will be added to the end of the base_url
  and a map of params which will be the body of the post request
  """
  @spec put(String.t(), map()) :: {:ok, map()} | {:error, map()}
  def put(path, params \\ %{}) do
    create()
    |> Tesla.put(path, params)
  end

  @doc """
  Issue a delete request using the HTTP client

  Accepts path which is the url path of the request, will be added to the end of the base_url
  """
  @spec delete(String.t()) :: {:ok, map()} | {:error, map()}
  def delete(path) do
    create()
    |> Tesla.delete(path)
  end

  defp map_to_klist(dict) do
    Enum.map(dict, fn {key, value} -> {to_atom(key), value} end)
  end

  defp to_atom(atom) when is_atom(atom), do: atom
  defp to_atom(string), do: String.to_atom(string)

  defp create() do
    middleware = [
      {Tesla.Middleware.BaseUrl, api_host()},
      {Tesla.Middleware.Headers, default_headers()},
      Tesla.Middleware.EncodeJson,
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
