defmodule FontAwesome.MixProject do
  use Mix.Project

  def project do
    [
      app: :fontawesome,
      version: "0.3.1",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "FontAwesome",
      description: "Phoenix components for Font Awesome!",
      source_url: "https://github.com/aptinio/fontawesome_elixir",
      docs: docs(),
      package: package(),
      xref: [exclude: [:httpc, :public_key]],
      aliases: aliases(),
      preferred_cli_env: [ci: :test]
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
      {:castore, ">= 0.0.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:phoenix_live_view, "~> 0.18"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      filter_modules: "FontAwesome",
      api_reference: false
    ]
  end

  defp package do
    [
      files: ~w[lib/fontawesome.ex LICENSE mix.exs README.md],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/aptinio/fontawesome_elixir"}
    ]
  end

  defp aliases do
    [
      ci: [
        "compile --force --warnings-as-errors --all-warnings",
        "deps.unlock --check-unused",
        "format --check-formatted",
        "test --warnings-as-errors"
      ]
    ]
  end
end
