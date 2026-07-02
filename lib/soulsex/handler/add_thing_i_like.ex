defmodule Soulsex.Handler.AddThingILike do
  @moduledoc """
  Handler for the `Soulseek.Server.AddThingILike` message.
  """

  require Logger

  @behaviour Soulsex.Handler

  alias Soulseek.Server.AddThingILike
  alias Soulsex.Connection.State

  @impl true
  @spec handle_message(AddThingILike.t(), State.t()) :: Soulsex.Handler.result()
  def handle_message(
        %AddThingILike{} = message,
        state
      ) do
    Logger.debug("received AddThingILike message: #{inspect(message)}")

    {:ok, state}
  end
end
