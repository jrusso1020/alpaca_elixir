defmodule Alpaca.Resource do
  @moduledoc """
  This module uses a macro to allow us to easily create the base
  HTTP methods for an Alpaca Resource. Most Alpaca requests have
  a common set of methods to get a specific resource by ID, list
  all resources, update the resource, delete all resources
  and delete a resource by id. By using this macro we can easily
  build out new API endpoints in a single line of code.

  ### Example
  ```
  defmodule Alpaca.NewResource do
    use Alpaca.Resource, endpoint: "new_resources"
  end
  ```

  We that single line of code we will now have a `list/0`, `list/1`,
  `get/1`, `get/2`, `create/1`, `edit/2`, `delete_all/0`, and `delete/1`
  functions for a given resource.

  You can also exclude functions from being created by passing them as a list
  of atoms with the `:exclude` keyword in the resource definition.

  ### Example
  ```
  defmodule Alpaca.NewResource do
    use Alpaca.Resource, endpoint: "new_resources", exclude: [:delete_all, :delete]
  end
  ```

  This definition will not create a `delete_all/0` or `delete/1` endpoint for the
  new resource you have defined.
  """
  defmacro __using__(options) do
    endpoint = Keyword.fetch!(options, :endpoint)
    exclude = Keyword.get(options, :exclude, [])
    opts = Keyword.get(options, :opts, [])

    quote do
      alias Alpaca.Client

      unless :list in unquote(exclude) do
        @doc """
        A function to list all resources from the Alpaca API
        """
        @spec list(map()) :: {:ok, [map()]} | {:error, map()}
        def list(params \\ %{}) do
          Client.get(base_url(), params, unquote(opts))
        end
      end

      unless :get in unquote(exclude) do
        @doc """
        A function to get a singlular resource from the Alpaca API
        """
        @spec get(String.t(), map()) :: {:ok, map()} | {:error, map()}
        def get(id, params \\ %{}) do
          Client.get(resource_url(id), params, unquote(opts))
        end
      end

      unless :create in unquote(exclude) do
        @doc """
        A function to create a new resource from the Alpaca API
        """
        @spec create(map()) :: {:ok, map()} | {:error, map()}
        def create(params) do
          Client.post(base_url(), params, unquote(opts))
        end
      end

      unless :edit in unquote(exclude) do
        @doc """
        A function to edit an existing resource using the Alpaca API
        """
        @spec edit(String.t(), map()) :: {:ok, map()} | {:error, map()}
        def edit(id, params) do
          Client.patch(resource_url(id), params, unquote(opts))
        end
      end

      unless :update in unquote(exclude) do
        @doc """
        A function to update an existing resource using the Alpaca API
        """
        @spec update(String.t(), map()) :: {:ok, map()} | {:error, map()}
        def update(id, params) do
          Client.put(resource_url(id), params, unquote(opts))
        end
      end

      unless :delete_all in unquote(exclude) do
        @doc """
        A function to delete all resources of a given type using the Alpaca API
        """
        @spec delete_all() :: {:ok, [map()]} | {:error, map()}
        def delete_all() do
          with {:ok, response_body} <- Client.delete(base_url(), unquote(opts)) do
            {:ok,
             Enum.map(response_body, fn item ->
               %{
                 status: item.status,
                 id: item[:id] || item[:symbol],
                 resource: item.body
               }
             end)}
          end
        end
      end

      unless :delete in unquote(exclude) do
        @doc """
        A function to delete a singular resource of a given type using the Alpaca API
        """
        @spec(delete(String.t()) :: :ok, {:error, map()})
        def delete(id) do
          Client.delete(resource_url(id), unquote(opts))
        end
      end

      @spec base_url :: String.t()
      defp base_url() do
        version = Keyword.get(unquote(opts), :version, "v2")

        "/#{version}/#{unquote(endpoint)}"
      end

      @spec resource_url(String.t()) :: String.t()
      defp resource_url(resource_id), do: "#{base_url()}/#{resource_id}"
    end
  end
end
