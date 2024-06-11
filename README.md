# alpaca_elixir [![Coverage Status](https://coveralls.io/repos/github/jrusso1020/alpaca_elixir/badge.svg?branch=master)](https://coveralls.io/github/jrusso1020/alpaca_elixir?branch=master) [![jrusso1020](https://circleci.com/gh/jrusso1020/alpaca_elixir.svg?style=svg)](https://circleci.com/gh/jrusso1020/alpaca_elixir)

An Elixir wrapper for the [Alpaca](https://alpaca.markets/) web api v1 for trading stocks commission free.

## Installation

The package can be installed
by adding `alpaca_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:alpaca_elixir, "~> 2.1.0"}
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

To configure your app to make calls to Alpaca setup your configuration using the proper values like below

```elixir
config :alpaca_elixir,
  api_host: System.get_env("ALPACA_API_HOST"),
  client_id: System.get_env("ALPACA_CLIENT_ID"),
  client_secret: System.get_env("ALPACA_CLIENT_SECRET")
```

## Testing

You can run tests using `mix test` generally

### Testing using Docker Container

If you would like to use the Docker container you can use the following commands in your terminal to build the Docker image, start the container, and start an interactive bash session within the container.

```bash
docker build -t alpaca-elixir .
docker run -it -t alpaca-elixir bash
```

Once you have access to the interactive bash session you should be able to run tests like so.

```bash
mix test
```
