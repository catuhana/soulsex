import Config

if port = System.get_env("PORT") do
  config :soulsex, port: String.to_integer(port)
end
