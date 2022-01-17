FROM elixir:1.13.1-alpine

ARG MIX_ENV=dev

COPY . /app
WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force && \
    MIX_ENV=${MIX_ENV} mix deps.get && \
    MIX_ENV=${MIX_ENV} mix deps.compile && \
    MIX_ENV=${MIX_ENV} mix compile
