defmodule Soulsex.Repo do
  use Ecto.Repo,
    otp_app: :soulsex,
    adapter: Ecto.Adapters.SQLite3
end
