
# General application configuration
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :elixir_monitoring_prom, ElixirMonitoringProm.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :elixir_monitoring_prom, ElixirMonitoringPromWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base


# config :elixir_monitoring_prom,
#   ecto_repos: [ElixirMonitoringProm.Repo]

# Configures the endpoint
# config :elixir_monitoring_prom, ElixirMonitoringPromWeb.Endpoint,
#   url: [host: "localhost"],
#   secret_key_base: "nFSyXdlKCXuXTXWhnmEeVnA9VLzzbpuqX3UvpdaPo8uqpgjxd+cZorH+0GobASx8",
#   # http: [:inet6, port: 4000],
#   render_errors: [view: ElixirMonitoringPromWeb.ErrorView, accepts: ~w(html json)],
#   pubsub: [name: ElixirMonitoringProm.PubSub, adapter: Phoenix.PubSub.PG2],
#   instrumenters: [ElixirMonitoringProm.PhoenixInstrumenter]

# config :elixir_monitoring_prom, ElixirMonitoringProm.Repo,
#   username: "postgres",
#   password: "postgres",
#   database: "elixir_monitoring_prom_dev",
#   hostname: "postgres",
#   show_sensitive_data_on_connection_error: true,
#   pool_size: 10

# config :prometheus, ElixirMonitoringProm.PipelineInstrumenter,
#   labels: [:status_class, :method, :host, :scheme, :request_path],
#   duration_buckets: [
#     10,
#     100,
#     1_000,
#     10_000,
#     100_000,
#     300_000,
#     500_000,
#     750_000,
#     1_000_000,
#     1_500_000,
#     2_000_000,
#     3_000_000
#   ],
#   registry: :default,
#   duration_unit: :microseconds

# # Configures Elixir's Logger
# config :logger, :console,
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id]

# # Use Jason for JSON parsing in Phoenix
# config :phoenix, :json_library, Jason

