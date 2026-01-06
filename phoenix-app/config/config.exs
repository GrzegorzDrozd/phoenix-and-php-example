# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :phoenix_app,
  ecto_repos: [PhoenixApp.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configure the endpoint
config :phoenix_app, PhoenixAppWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: PhoenixAppWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PhoenixApp.PubSub,
  live_view: [signing_salt: "upcZldAI"]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :phoenix_app, PhoenixApp.Importer,
  female_first_names_url:
    "https://api.dane.gov.pl/media/resources/20250124/7_-_Wykaz_imion_%C5%BCe%C5%84skich_wg_pola_imi%C4%99_pierwsze_wyst%C4%99puj%C4%85cych_w_rejestrze_PESEL_z_uwzgl%C4%99dnieniem_imion_os%C3%B3b_zmar%C5%82ych.csv",
  male_first_names_url:
    "https://api.dane.gov.pl/media/resources/20250124/7_-_Wykaz_imion_m%C4%99skich_wg_pola_imi%C4%99_pierwsze_wyst%C4%99puj%C4%85cych_w_rejestrze_PESEL_z_uwzgl%C4%99dnieniem_imion_os%C3%B3b_zmar%C5%82ych.csv",
  female_last_names_url:
    "https://api.dane.gov.pl/media/resources/20250123/nazwiska_%C5%BCe%C5%84skie-osoby_%C5%BCyj%C4%85ce_efby1gw.csv",
  male_last_names_url:
    "https://api.dane.gov.pl/media/resources/20250123/nazwiska_m%C4%99skie-osoby_%C5%BCyj%C4%85ce.csv"
