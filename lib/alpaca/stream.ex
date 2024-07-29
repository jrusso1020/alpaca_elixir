defmodule Alpaca.Stream do
  @moduledoc ~S"""
  The Alpaca.Stream module handles negotiating the connection, then sending frames, receiving
  frames, closing, and reconnecting that connection for the websocket streaming API of Alpaca.
  A simple client implementation would be:
  ```
  defmodule AlpacaStreamClient do
    use Alpaca.Stream, url: "https://paper-api.alpaca.markets/stream"

    def start_link() do
      start_link(["account_updates", "trade_updates"])
    end

    @impl Alpaca.Stream
    def handle_msg(msg, state) do
      IO.puts "Received a message: #{msg}"
      {:ok, state}
    end
  end
  ```

  The `url` keyword is optional and if omitted will be defaulted to `"#{Client.api_host()}/stream"`
  to key backwards compatibility.

  ## Supervision
  Alpaca.Stream uses WebSockex under the hood

  WebSockex is implemented as an OTP Special Process and as a result will fit
  into supervision trees.
  WebSockex also supports the Supervisor children format introduced in Elixir
  1.5. Meaning that a child specification could be `{ClientModule, [state]}`.
  However, since there is a possibility that you would like to provide a
  `t:WebSockex.Conn/0` or a url as well as the state, there are two versions of
  the `child_spec` function. If you need functionality beyond that it is
  recommended that you override the function or define your own.
  Just remember to use the version that corresponds with your `start_link`'s
  arity.
  """

  @doc ~S"""
  Define how we want to handle the messages we receive from the websocket
  You can expect them to be a map since we will decode them from a binary
  to a json.

  ### Example
  ```
  defmodule TestStream do
    use Alpaca.Stream, url: "wss://data.alpaca.markets/stream"

    @impl Alpaca.Stream
    def handle_msg(msg, state) do
      IO.puts "Received a message: #{inspect(msg)}"
      {:ok, state}
    end
  end
  ```
  """
  @callback handle_msg(msg :: map, state :: term) ::
              {:ok, new_state}
              | {:reply, WebSockex.frame(), new_state}
              | {:close, new_state}
              | {:close, WebSockex.close_frame(), new_state}
            when new_state: term

  defmacro __using__(opts \\ []) do
    url = Keyword.get(opts, :url, "#{Alpaca.Client.api_host()}/stream")

    quote do
      use WebSockex

      @behaviour Alpaca.Stream

      alias Alpaca.Client

      @doc """
      Allows us to start a process for our websocket stream. You can pass it an optional value of
      a list which includes the streams you would like to receive updates for. The two possible
      stream types are `"account_updates"` and `"trade_updates"`. It will return an `:ok` result
      tuple with the `pid` of the process started like so `{:ok, pid}`.

      This `start_link` function will automatically authenticate based on the credentials set
      in the application and tell the stream to listen for any updates on the streams passed in
      if any. If no streams are passed in the start_link you can also later on pass them in
      using the `listen` method.

      ### Example
      ```
      defmodule TestStream do
        use Alpaca.Stream
        def start_link() do
          start_link(["account_updates", "trade_updates"])
        end
      end
      ```
      """
      def start_link(streams, opts \\ []) do
        {:ok, pid} = WebSockex.start_link(unquote(url), __MODULE__, :no_state, opts)
        authenticate(pid)

        unless streams == [] do
          listen(pid, streams)
        end

        {:ok, pid}
      end

      @doc """
      This `handle_frame` function will automatically handle any `:binary` message frames we get
      on the websocket stream and call your defined `handle_msg` function in your Alpaca.Stream
      behavior. You can also optional choose to define additional `handle_frame` functions for
      other message types if need be.
      """
      def handle_frame({:binary, msg}, state) do
        __MODULE__.handle_msg(Jason.decode!(msg), state)
      end

      @doc """
      This `listen` function can be used to tell our websocket to listen on either the
      `"account_updates"` stream and/or the `"trade_updates"` stream. It expects the `pid`
      of the websocket process and the `streams` as a list of strings.

      ### Example
      ```
      defmodule TestStream do
        use Alpaca.Stream

        def start_link()
          start_link([])
          listen(["account_updates"])
          listen(["trade_updates"])
        end
      end
      ```
      """
      def listen(pid, streams) do
        frame = listen_frame(streams)
        WebSockex.send_frame(pid, frame)
      end

      @doc """
      This `authenticate` function can be used to authenticate your websocket stream.
      It will automatically be called with the credentials set in your app config.
      It is used automatically by the `start_link` method, and can be used to define
      your own reconnect callbacks.
      """
      def authenticate(pid) do
        frame = authentication_frame()
        WebSockex.send_frame(pid, frame)
      end

      defp authentication_frame do
        authentication_json =
          %{
            action: "auth",
            key: Client.client_id(),
            secret: Client.client_secret()
          }
          |> Jason.encode!()

        {:text, authentication_json}
      end

      defp listen_frame(streams) do
        listen_json =
          %{
            action: "listen",
            data: %{
              streams: streams
            }
          }
          |> Jason.encode!()

        {:text, listen_json}
      end
    end
  end
end
