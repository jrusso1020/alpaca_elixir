defmodule Alpaca.ResponseMiddleware do
  @moduledoc """
  This middleware handles responses from the Alpaca API and
  returns it in a result tuple of either {:ok, reponse_body} or
  {:error, error_message}.

  This allows us to easily handle all of our responses in a uniform
  way.


  ### Example usage

  ```
  defmodule Alpaca.Client do
    use Tesla

    plug Alpaca.ResponseMiddleware
  end
  ```

  ### Options
  There are no options at the current moment in time
  """
  @behaviour Tesla.Middleware

  def call(env, next, _options) do
    env
    |> Tesla.run(next)
    |> handle_response()
  end

  defp handle_response({:ok, response}) do
    case response.status do
      204 ->
        :ok

      status when status in 200..299 ->
        {:ok, Jason.decode!(response.body, keys: :atoms)}

      status when status in 400..599 ->
        {:error, %{status: status, body: Jason.decode!(response.body, keys: :atoms)}}
    end
  end

  defp handle_response(response), do: response
end
