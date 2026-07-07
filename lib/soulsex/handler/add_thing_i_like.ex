defmodule Soulsex.Handler.AddThingILike do
  @moduledoc false

  alias Soulseek.Server.AddThingILike
  alias Soulsex.Connection.State
  alias Soulsex.Handler.Notification

  @behaviour Notification

  @impl true
  @spec acknowledge(AddThingILike.t(), State.t()) :: Notification.result()
  def acknowledge(
        %AddThingILike{} = _message,
        state
      ) do
    {:ok, state}
  end
end
