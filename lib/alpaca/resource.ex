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

    quote do
      alias Alpaca.Client

      unless :list in unquote(exclude) do
        @doc """
        A function to list all resources from the Alpaca API
        """
        @spec list(Map.t()) :: {:ok, [__MODULE__.t()]} | {:error, Map.t()}
        def list(params \\ %{}) do
          with {:ok, resources} <- Client.get(base_url(), params) do
            {:ok, Enum.map(resources, fn resource -> struct(__MODULE__, resource) end)}
          end
        end
      end

      unless :get in unquote(exclude) do
        @doc """
        A function to get a singlular resource from the Alpaca API
        """
        @spec get(String.t(), Map.t()) :: {:ok, __MODULE__.t()} | {:error, Map.t()}
        def get(id, params \\ %{}) do
          with {:ok, resource} <- Client.get(resource_url(id), params) do
            {:ok, struct(__MODULE__, resource)}
          end
        end
      end

      unless :create in unquote(exclude) do
        @doc """
        A function to create a new resource from the Alpaca API
        """
        @spec create(Map.t()) :: {:ok, __MODULE__.t()} | {:error, Map.t()}
        def create(params) do
          with {:ok, resource} <- Client.post(base_url(), params) do
            {:ok, struct(__MODULE__, resource)}
          end
        end
      end

      unless :edit in unquote(exclude) do
        @doc """
        A function to edit an existing resource using the Alpaca API
        """
        @spec edit(String.t(), Map.t()) :: {:ok, __MODULE__.t()} | {:error, Map.t()}
        def edit(id, params) do
          with {:ok, resource} <- Client.patch(resource_url(id), params) do
            {:ok, struct(__MODULE__, resource)}
          end
        end
      end

      unless :delete_all in unquote(exclude) do
        @doc """
        A function to delete all resources of a given type using the Alpaca API
        """
        @spec delete_all() :: {:ok, [Map.t()]} | {:error, Map.t()}
        def delete_all() do
          with {:ok, response_body} <- Client.delete(base_url()) do
            {:ok,
             Enum.map(response_body, fn item ->
               %{
                 status: item.status,
                 id: item.id,
                 resource: delete_all_resource_body(item.body)
               }
             end)}
          end
        end
      end

      unless :delete in unquote(exclude) do
        @doc """
        A function to delete a singular resource of a given type using the Alpaca API
        """
        @spec(delete(String.t()) :: :ok, {:error, Map.t()})
        def delete(id) do
          with :ok <- Client.delete(resource_url(id)) do
            :ok
          end
        end
      end

      defp delete_all_resource_body(nil), do: nil

      defp delete_all_resource_body(resource), do: struct(__MODULE__, resource)

      @spec base_url :: String.t()
      defp base_url, do: "/v2/#{unquote(endpoint)}"

      @spec resource_url(String.t()) :: String.t()
      defp resource_url(resource_id), do: "#{base_url()}/#{resource_id}"
    end
  end
end
