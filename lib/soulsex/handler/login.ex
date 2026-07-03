defmodule Soulsex.Handler.Login do
  @moduledoc false

  require Logger

  @behaviour Soulsex.Handler

  alias Soulseek.Server.Login.{Failure, Request, Success}
  alias Soulsex.Accounts
  alias Soulsex.Connection.{Registry, State}

  # TODO: Align with `Soulseek.LoginRejectionReason` somehow.
  @known_rejection_reasons [
    :empty_password,
    :invalid_password,
    :invalid_version,
    :server_full,
    :server_private
  ]

  @impl true
  @spec handle_message(Request.t(), State.t()) :: Soulsex.Handler.result()
  def handle_message(%Request{username: username, password: password} = request, state) do
    Logger.debug("#{inspect(__MODULE__)}=#{inspect(request)}")

    username
    |> Accounts.login(password)
    |> reply(password, state)
  end

  @spec reply({:ok, Accounts.User.t()} | {:error, Accounts.login_error()}, String.t(), State.t()) ::
          Soulsex.Handler.result()
  defp reply({:ok, user}, password, state) do
    Accounts.touch_last_login(user)

    ip = peer_ip(state.socket, state.transport)

    meta = %{
      ip: ip,
      port: nil,
      obfuscation_type: nil,
      obfuscated_port: nil
    }

    case Registry.register(user.username, meta) do
      {:ok, _pid} ->
        :ok
    end

    success = %Success{
      # TODO: Make this configurable and a *global*.
      greet: "meow",
      ip_address: ip_uint32(ip),
      hash:
        :crypto.hash(:md5, password)
        |> Base.encode16(case: :lower),
      # TODO: Fetch from `supporters` table.
      supporter: false
    }

    Logger.debug("login succeeded=#{inspect(success)}")

    {:reply, success, %{state | user_id: user.id, username: user.username}}
  end

  defp reply({:error, {:invalid_username, detail}}, _password, state) do
    failure = %Failure{reason: :invalid_username, detail: detail}

    Logger.warning("login rejected=#{inspect(failure)}")

    {:reply_and_close, failure, state}
  end

  defp reply({:error, reason}, _password, state) when reason in @known_rejection_reasons do
    failure = %Failure{reason: reason, detail: nil}

    Logger.warning("login rejected=#{inspect(failure)}")

    {:reply_and_close, failure, state}
  end

  defp peer_ip(socket, transport) do
    case transport.peername(socket) do
      {:ok, {ip, _port}} -> ip
      {:error, _reason} -> {0, 0, 0, 0}
    end
  end

  defp ip_uint32({a, b, c, d}) do
    d + c * 256 + b * 65_536 + a * 16_777_216
  end
end
