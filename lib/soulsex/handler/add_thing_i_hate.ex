defmodule Soulsex.Handler.AddThingIHate do
  @moduledoc false

  alias Soulseek.Server.AddThingIHate
  alias Soulsex.Connection.State
  alias Soulsex.Handler.Notification

  @behaviour Notification

  @impl true
  @spec acknowledge(AddThingIHate.t(), State.t()) :: Notification.result()
  def acknowledge(
        %AddThingIHate{} = _message,
        state
      ) do
    {:ok, state}
  end
end
