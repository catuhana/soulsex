defmodule Soulsex.Handler do
  @moduledoc """
  Dispatches to a Soulseek connection handler module, regardless of whether
  it implements `Soulsex.Handler.Notification` or `Soulsex.Handler.Repliable`.
  """

  alias Soulsex.Connection.State
  alias Soulsex.Handler.{Notification, Repliable}

  @type common_result ::
          {:error, reason :: term(), new_state :: State.t()}
          | :close

  @type result :: Notification.result() | Repliable.result()
end
