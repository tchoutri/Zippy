defmodule Zippy.Mixfile do
  use Mix.Project

  def project do
    [app: :zippy,
     name: "Zippy",
     source_url: "https://github.com/tchoutri/zippy",
     version: "0.0.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     docs: [main: "Zippy"],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp description do
    """
    An Elixir implementation of Zipper lists, binary trees and forests.
    """
  end

  defp package do
    [
      name: :zippy,
      files: ["lib", "mix.exs", "README.rst"],
      maintainers: ["Théophile Choutri"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/tchoutri/zippy"}
    ]
  end

  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev}]
  end
end
