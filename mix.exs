defmodule Nursery.MixProject do
  use Mix.Project

  def project do
    [
      app:               :nursery,
      version:           "0.2.1",
      elixir:            "~> 1.16",
      start_permanent:   Mix.env() == :prod,
      elixirc_paths:     elixirc_paths(Mix.env()),
      deps:              deps(),
      description:       "Supervise your children in the appropriate environment",
      package:           [
        licenses: ["MIT"],
        links:    %{"GitHub" => "https://github.com/mpol1t/nursery"}
      ],
      test_coverage:     [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls:             :test,
        "coveralls.detail":    :test,
        "coveralls.post":      :test,
        "coveralls.html":      :test,
        "coveralls.cobertura": :test
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc,      "~> 0.38.3", only: [:dev],  runtime: false},
      {:credo,       "~> 1.7",    only: [:dev],  runtime: false},
      {:dialyxir,    "~> 1.4",    only: [:dev],  runtime: false},
      {:excoveralls, "~> 0.18.5", only: [:test], runtime: false},
      {:stream_data, "~> 1.2",    only: [:test], runtime: false}
    ]
  end
end
