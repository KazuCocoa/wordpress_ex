defmodule WordpressEx.Mixfile do
  use Mix.Project

  def project() do
    [app: :wordpress_ex,
     version: "0.0.2",
     elixir: "~> 1.11",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application() do
    [applications: [:logger, :httpoison]]
  end

  defp deps() do
    [
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"}
    ]
  end
end
