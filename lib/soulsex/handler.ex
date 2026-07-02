defmodule Soulsex.Handler do
  @moduledoc """
  Behaviour for a Soulseek connection handler.
  """

  @callback handle_message(message :: Soulseek.Message.t(), state :: Soulsex.Connection.State.t()) ::
              {:ok, new_state :: Soulsex.Connection.State.t()}
              | {:reply, response :: Soulseek.Message.t(),
                 new_state :: Soulsex.Connection.State.t()}
              | {:error, reason :: term(), new_state :: Soulsex.Connection.State.t()}
end
