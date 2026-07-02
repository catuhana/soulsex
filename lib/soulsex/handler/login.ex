defmodule Soulsex.Handler.Login do
  @moduledoc """
  Handler for the `Soulseek.Server.Login` message.
  """

  require Logger

  @behaviour Soulsex.Handler

  alias Soulseek.Server.Login.{Request, Success}
  alias Soulsex.Connection.State

  @impl true
  @spec handle_message(Request.t(), State.t()) :: Soulsex.Handler.result()
  def handle_message(
        %Request{} = request,
        state
      ) do
    Logger.debug("received Login message: #{inspect(request)}")

    success = %Success{
      greet: "meow",
      ip_address: 2_130_706_433,
      hash: "hashbrown",
      supporter: true
    }

    Logger.debug("sending Login.Success response: #{inspect(success)}")

    {:reply, success, state}
  end
end
