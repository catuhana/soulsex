defmodule Soulsex.Handler.Repliable do
  @moduledoc false

  alias Soulseek.Message
  alias Soulsex.Connection.State
  alias Soulsex.Handler

  @type result ::
          {
            :reply,
            response :: Message.t(),
            new_state :: State.t()
          }
          | {
              :reply_and_close,
              response :: Soulseek.Message.t(),
              new_state :: State.t()
            }
          | Handler.common_result()

  @callback respond(message :: Message.t(), state :: State.t()) ::
              result()
end
