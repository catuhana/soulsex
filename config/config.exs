import Config

config :soulsex, port: 2242, greet: "Welcome to Soulsex!"
config :soulsex, ecto_repos: [Soulsex.Repo]

import_config "#{config_env()}.exs"
