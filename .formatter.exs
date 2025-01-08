[
  import_deps: [:ash_authentication_phoenix, :ash_authentication, :ash, :phoenix, :ash_sqlite],
  plugins: [Spark.Formatter, Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}"]
]
