defmodule Soulsex.Handler.Notification do
  @moduledoc """
  Behaviour for handlers of messages that never send a response
  back to the peer and update the local state instead.
  """

  alias Soulseek.Message
  alias Soulsex.Connection.State
  alias Soulsex.Handler

  @type result ::
          {
            :ok,
            new_state :: State.t()
          }
          | Handler.common_result()

  @callback acknowledge(message :: Message.t(), state :: State.t()) ::
              result()
end
