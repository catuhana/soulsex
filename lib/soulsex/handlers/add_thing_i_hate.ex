defmodule Soulsex.Handlers.AddThingIHate do
  @moduledoc """
  Handler for the `Soulseek.Server.AddThingIHate` message.
  """

  require Logger

  @behaviour Soulsex.Handler

  alias Soulseek.Server.AddThingIHate
  alias Soulsex.Connection.State

  @impl true
  @spec handle_message(AddThingIHate.t(), State.t()) :: Soulsex.Handler.result()
  def handle_message(
        %AddThingIHate{} = message,
        state
      ) do
    Logger.debug("received AddThingIHate message: #{inspect(message)}")

    {:error, :not_implemented, state}
  end
end
