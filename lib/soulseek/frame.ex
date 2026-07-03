defmodule Soulseek.Frame do
  @moduledoc """
  Length-delimited framing for Soulseek connections.

  Every coded connection type (server, peer, peer init, distributed) prefixes
  each message with a little-endian `uint32` length counting the message code
  plus its payload. `decode/2` peels one such frame off the front of a buffer,
  enforcing a maximum size so a malicious length cannot force unbounded
  buffering.

  It returns the raw frame body (code + payload) and does not interpret it:
  reading the code (a `uint32` for server and peer, a `uint8` for peer init and
  distributed) and decoding the payload are the caller's concern. File
  connections are unframed and are not handled here.
  """

  @doc """
  Wraps a message code and encoded payload into a length-delimited frame.

  Returns iodata ready for `transport.send/2`.
  """
  @spec encode(non_neg_integer(), iodata()) :: iodata()
  def encode(code, payload) do
    body = [<<code::little-32>>, payload]
    length = IO.iodata_length(body)

    [<<length::little-32>>, body]
  end

  @doc """
  Peels one length-delimited frame off the front of `buffer`.

    - `{:ok, body, rest}` when a whole frame is present; `body` is the code plus
      payload and `rest` is the unconsumed remainder.
    - `:more` when `buffer` does not yet hold a complete frame.
    - `{:error, :too_large}` when the declared length exceeds `max_size`.
  """
  @spec decode(binary(), pos_integer()) ::
          {:ok, binary(), binary()} | :more | {:error, :too_large}
  def decode(<<length::little-32, body_and_rest::binary>>, max_size) do
    cond do
      length > max_size ->
        {:error, :too_large}

      byte_size(body_and_rest) < length ->
        :more

      true ->
        <<body::binary-size(^length), rest::binary>> = body_and_rest
        {:ok, body, rest}
    end
  end

  def decode(_buffer, _max_size), do: :more
end
