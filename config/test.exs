import Config

config :pash, token_signing_secret: "qLMqw8oXh5a2N6MZ/hADT+S4FFUg/mAa"

config :pash, Pash.Repo,
  database: Path.join(__DIR__, "../path/to/your#{System.get_env("MIX_TEST_PARTITION")}.db"),
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pash, PashWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "YcRWgI4fS1ANoQhxpl+1AAV4v9m3mq03fLWxSjdZDHDdW2RKNXdlMyyQEku4MEhe",
  server: false

# In test we don't send emails
config :pash, Pash.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
