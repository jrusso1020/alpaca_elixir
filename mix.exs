defmodule AlpacaElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :alpaca_elixir,
      version: "1.0.0",
      elixir: "~> 1.10",
      preferred_cli_env: ["coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      description: "Alpaca Elixir Library",
      package: package(),
      deps: deps(),

      # Docs
      name: "AlpacaElixir",
      source_url: "https://github.com/jrusso1020/alpaca_elixir",
      homepage_url: "https://github.com/jrusso1020/alpaca_elixir",
      docs: [
        main: "AlpacaElixir",
        extra: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:confex, "~> 3.4.0"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:exvcr, "~> 0.11", only: :test},
      {:hackney, "~> 1.16.0"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:jason, "~> 1.2"},
      {:tesla, "~> 1.3.0"},
      {:websockex, "~> 0.4.2"}
    ]
  end

  defp package do
    [
      maintainers: ["James Russo"],
      files: ["lib/**/*.ex", "mix*", "*.md"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jrusso1020/alpaca_elixir"}
    ]
  end
end
