defmodule Soulseek.Frame do
  @moduledoc false

  @spec encode(non_neg_integer(), iodata()) :: iodata()
  def encode(code, payload) do
    body = [<<code::little-32>>, payload]
    length = IO.iodata_length(body)

    [<<length::little-32>>, body]
  end

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
