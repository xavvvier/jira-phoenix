# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :jira, Jira.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3jOswdWPKhbpPPRZXprYiVk2WTsXkDLTWIg/DXnBcwldeSb4kLK9JNyc7O0VntID",
  render_errors: [view: Jira.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Jira.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :jira, time_zone_offset: -500

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
