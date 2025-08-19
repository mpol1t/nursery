defmodule Nursery.MixProject do
  use Mix.Project

  def project do
    [
      app:               :nursery,
      version:           "0.1.0",
      elixir:            "~> 1.16",
      start_permanent:   Mix.env() == :prod,
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

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.18.5", only: [:test], runtime: false}
    ]
  end
end
