# alpaca_elixir
An Elixir wrapper for the [Alpaca](https://alpaca.markets/) web api v2 for trading stocks commission free.

## Installation

The package can be installed
by adding `alpaca_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:alpaca_elixir, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/alpaca_elixir](https://hexdocs.pm/alpaca_elixir).

## Getting Started
### Registration
This library requires a valid Alpaca Client ID and Secret to work. You can get both a Client ID and Secret by creating an account at [Alpaca](https://alpaca.markets/). Once you have created an account you will need to create an OAuth app to get access to a Client ID and Secret.

### Client ID and Secret Configuration



## Testing
### Testing using Docker Container
Run the following commands in your terminalto build the Docker image, start the container, and start an interactive bash session within the container.
```bash
docker build -t alpaca-elixir .
docker run -it -t alpaca-elixir bash
```

Once you have access to the interactive bash session you should be able to run tests like so.
```bash
mix test
```


