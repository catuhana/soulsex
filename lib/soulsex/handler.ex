defmodule Soulsex.Handler do
  @moduledoc false

  alias Soulsex.Connection.State
  alias Soulsex.Handler.{Notification, Repliable}

  @type common_result ::
          {:error, reason :: term(), new_state :: State.t()}
          | :close

  @type result :: Notification.result() | Repliable.result()
end
