defmodule Soulsex.Handler do
  @moduledoc false

  alias Soulsex.Connection.State
  alias Soulsex.Handler.{Notification, Repliable}

  @type error_reason ::
          {:unknown_code, non_neg_integer()}
          | {:decode_failed, module()}
          | {:unregistered_peer, String.t()}

  @type common_result ::
          {:error, error_reason(), new_state :: State.t()} | :close

  @type result :: Notification.result() | Repliable.result()
end
