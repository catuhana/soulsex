defmodule Soulsex.Handler.AddThingILike do
  @moduledoc """
  Handler for the `Soulseek.Server.AddThingILike` message.
  """

  @behaviour Soulsex.Handler

  alias Soulseek.Server.AddThingILike
  alias Soulsex.Connection.State

  @impl true
  @spec handle_message(AddThingILike.t(), State.t()) :: Soulsex.Handler.result()
  def handle_message(
        %AddThingILike{} = _message,
        state
      ) do
    {:ok, state}
  end
end
