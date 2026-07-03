import Config

if port = System.get_env("PORT") do
  config :soulsex, port: String.to_integer(port)
end

# Maybe we can turn this into something more dynamic,
# like a MOTD that can be changed without restarting
# the whole server.
if greet = System.get_env("GREET") do
  config :soulsex, greet: greet
end

if config_env() == :prod do
  database_path =
    System.get_env("DATABASE_PATH") || raise "DATABASE_PATH is not set"

  config :soulsex, Soulsex.Repo, database: database_path
end
