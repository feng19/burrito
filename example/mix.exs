defmodule ExampleCliApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :example_cli_app,
      releases: releases(),
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def releases do
    [
      example_cli_app: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            macos: [os: :darwin, cpu: :x86_64],
            macos_m1: [os: :darwin, cpu: :aarch64],
            linux: [os: :linux, cpu: :x86_64],
            linux_musl: [os: :linux, cpu: :x86_64, libc: :musl],
            windows: [os: :windows, cpu: :x86_64]
          ],
          extra_steps: [
            fetch: [pre: [ExampleCliApp.CustomBuildStep]],
            build: [post: [ExampleCliApp.CustomBuildStep]]
          ],
          debug: Mix.env() != :prod,
          plugin: "./test_plugin/plugin.zig",
          no_clean: false
        ]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExampleCliApp, []}
    ]
  end

  defp deps do
    [
      {:burrito, path: "../"},
      {:exqlite, "~> 0.11.7"}
      # {:ex_termbox, "~> 1.0"},
    ]
  end
end
