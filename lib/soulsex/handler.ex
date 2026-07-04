# TODO: Split in to separate modules for messages that are
# repliable vs non-repliable. Not on every message the server
# sends a reply - we just acknowledge it, store it in the State
# or registry or whatever.
defmodule Soulsex.Handler do
  @moduledoc """
  Behaviour for a Soulseek connection handler.
  """

  @type result ::
          {:ok, new_state :: Soulsex.Connection.State.t()}
          | {:reply, response :: Soulseek.Message.t(), new_state :: Soulsex.Connection.State.t()}
          | {:reply_and_close, response :: Soulseek.Message.t(),
             new_state :: Soulsex.Connection.State.t()}
          | {:error, reason :: term(), new_state :: Soulsex.Connection.State.t()}
          | :close

  @callback handle_message(message :: Soulseek.Message.t(), state :: Soulsex.Connection.State.t()) ::
              result()
end
