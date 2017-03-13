defmodule NektoClient.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nekto_client,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls, test_task: "espec"],
      preferred_cli_env: [espec: :test, coveralls: :test,
                          "coveralls.detail": :test, "coveralls.post": :test,
                          "coveralls.html": :test],
      name: "NektoClient",
      source_url: "https://github.com/NightWolf007/nekto_client_ex",
      docs: [main: "NektoClient", extras: ["README.md"]]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    []
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:socket, "~> 0.3"},
      {:httpoison, "~> 0.11"},
      {:poison, "~> 3.0"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:credo, "~> 0.6", only: [:dev, :test]},
      {:espec, "~> 1.3", only: :test},
      {:excoveralls, "~> 0.6", only: :test}
    ]
  end

  defp package do
    [
      name: :nekto_client,
      files: ["lib", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      maintainers: ["Dmitry Sinelnikov"],
      licenses: [],
      links: %{"GitHub" => "https://github.com/NightWolf007/nekto_client_ex"}
    ]
  end
end
