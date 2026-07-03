defmodule Soulsex.Handler.AddThingIHate do
  @moduledoc """
  Handler for the `Soulseek.Server.AddThingIHate` message.
  """

  @behaviour Soulsex.Handler

  alias Soulseek.Server.AddThingIHate
  alias Soulsex.Connection.State

  @impl true
  @spec handle_message(AddThingIHate.t(), State.t()) :: Soulsex.Handler.result()
  def handle_message(
        %AddThingIHate{} = _message,
        state
      ) do
    {:ok, state}
  end
end
