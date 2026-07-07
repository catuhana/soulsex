defmodule Soulsex.Handler.Notification do
  @moduledoc false

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
