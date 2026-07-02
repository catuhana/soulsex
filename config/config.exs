import Config

config :soulsex, port: 2242
config :soulsex, ecto_repos: [Soulsex.Repo]

import_config "#{config_env()}.exs"
