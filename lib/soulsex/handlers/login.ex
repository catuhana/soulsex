defmodule Soulsex.Handlers.Login do
  @moduledoc """
  Handler for the `Soulseek.Server.Login` message.
  """

  require Logger

  @behaviour Soulsex.Handler

  alias Soulseek.Server.Login.Request

  @impl true
  def handle_message(
        %Request{} = request,
        state
      ) do
    Logger.debug("received login request: #{inspect(request)}")

    {:ok, state}
  end
end
