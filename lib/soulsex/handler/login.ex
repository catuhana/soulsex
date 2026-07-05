defmodule Soulsex.Handler.Login do
  @moduledoc false

  require Logger

  @behaviour Soulsex.Handler

  alias Soulseek.Server.Login.{Failure, Request, Success}
  alias Soulsex.Accounts
  alias Soulsex.Connection.State
  alias Soulsex.PeerDirectory
  alias Soulsex.PeerDirectory.Entry.Pending
  alias Soulsex.Schema

  # TODO: Find a way to keep in sync with `LoginRejectionReason`.
  @known_rejection_reasons [
    :empty_password,
    :invalid_password,
    :invalid_version,
    :server_full,
    :server_private
  ]

  @takeover_timeout :timer.seconds(5)

  @impl true
  @spec handle_message(Request.t(), State.t()) :: Soulsex.Handler.result()
  def handle_message(%Request{username: username, password: password} = request, state) do
    Logger.debug("#{inspect(__MODULE__)}=#{inspect(request)}")

    username
    |> Accounts.login(password)
    |> reply(password, state)
  end

  @spec reply(
          {:ok, Schema.User.t()}
          | {:error, Accounts.login_error()},
          String.t(),
          State.t()
        ) ::
          Soulsex.Handler.result()
  defp reply({:ok, user}, password, state) do
    Accounts.touch_last_login(user)

    ip = peer_ip(state.socket, state.transport)
    {:ok, _pid} = register_peer(user.username, ip)

    success = %Success{
      greet: Application.get_env(:soulsex, :greet),
      ip_address: ip_uint32(ip),
      hash:
        :crypto.hash(:md5, password)
        |> Base.encode16(case: :lower),
      supporter: Accounts.supporter?(user)
    }

    Logger.debug("login succeeded=#{inspect(success)}")

    {:reply, success, %{state | user_id: user.id, username: user.username}}
  end

  defp reply({:error, {:invalid_username, detail}}, _password, state) do
    failure = %Failure{reason: :invalid_username, detail: detail}

    Logger.warning("login rejected=#{inspect(failure)}")

    {:reply_and_close, failure, state}
  end

  defp reply({:error, :registration_failed}, _password, state) do
    Logger.warning("registration failed for username=#{state.username}")

    :close
  end

  defp reply({:error, reason}, _password, state) when reason in @known_rejection_reasons do
    failure = %Failure{reason: reason, detail: nil}

    Logger.warning("login rejected=#{inspect(failure)}")

    {:reply_and_close, failure, state}
  end

  @spec register_peer(String.t(), :inet.ip4_address()) :: {:ok, pid()}
  defp register_peer(username, ip) do
    entry = %Pending{ip: ip}

    case PeerDirectory.register(username, entry) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_logged_in, old_pid}} ->
        take_over(username, entry, old_pid)
    end
  end

  defp take_over(username, entry, old_pid) do
    ref = Process.monitor(old_pid)
    send(old_pid, :relogged)

    receive do
      {:DOWN, ^ref, :process, ^old_pid, _reason} ->
        Logger.debug("relogged previous session username=#{username} old_pid=#{inspect(old_pid)}")

        PeerDirectory.register(username, entry)
    after
      @takeover_timeout ->
        Logger.warning(
          "previous session unresponsive, force-killing username=#{username} old_pid=#{inspect(old_pid)}"
        )

        Process.exit(old_pid, :kill)

        receive do
          {:DOWN, ^ref, :process, ^old_pid, _reason} ->
            PeerDirectory.register(username, entry)
        end
    end
  end

  defp peer_ip(socket, transport) do
    case transport.peername(socket) do
      {:ok, {ip, _port}} -> ip
      {:error, _reason} -> {0, 0, 0, 0}
    end
  end

  defp ip_uint32({a, b, c, d}) do
    <<int::big-32>> = <<a, b, c, d>>
    int
  end
end
